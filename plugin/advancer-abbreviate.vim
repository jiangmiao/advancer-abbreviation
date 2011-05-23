" Advancer Abbreviate
" Maintainer: Miao Jiang <jiangfriend@gmail.com>
" Last Change: 2011-5-23
" Version: 1.0
" Homepage:
" Repository:

if exists('g:AbbrLoaded') || &cp
  finish
end
let g:AbbrLoaded = 1

if !exists('g:AbbrHint')
  let g:AbbrHint = ['\/\*TODO\*\/','#TODO#', "'TODO'", '<!--TODO-->']
end
let g:Abbrs = {}
let g:AbbrHintPattern = ''
function! AbbrJump()
  " expand abbr if abbr is valid.

  let is_eol = 0
  if col('$') == col('.')
    let is_eol=1
  else
    normal h
  end

  " Expand abbreviation
  let backup = @p
  let @p=''
  normal! "pciw;
  if match(@p, '^\w\+$') != -1 && has_key(g:Abbrs, 'abbr_'.@p)
    execute "normal clabbr_".@p
  else
      execute 'normal! cl'.@p
  end
  let @p = backup


  let start=line("'p")

  " Jump to TODO block
  let i = 0
  let cleaned = AbbrClean()
  if search(g:AbbrHintPattern,'W') 
    let hint = matchlist(getline('.'), g:AbbrHintPattern, col('.')-1)[0]
    let b:abbr_lastline = line('.')
    execute 'normal! cf'.hint[-1:].';'
    return "\<Del>"
  else
    if cleaned
      normal I;
      return "\<DEL>"
    end
  end

  if start == line('.') && line("'q")
    if line("'q'") != line('.')
      normal! `q
      return ""
    else
      normal! `q
    end
  end

  ""return start.' '.line('.').' '.line('`Q')
  return "\<Right>"
endfunction


function! AbbrBegin()
  mark p
  return ''
endfunction

function! AbbrEnd()
  normal mq`p
  return "\<Right>"
endfunction

function! AbbrCreate(args)
  let args = matchlist(a:args, '^\s*\(.\{-}\)\s\+\(.*\)$')
  if len(args) == 0
    return
  end

  let abbr_name    = args[1]

  if abbr_name == ''
    return
  end

  
  " Store abbr_name index to Abbrs
  let abbr_name = 'abbr_'.abbr_name
  let g:Abbrs[abbr_name] = 1

  let abbr_context = args[2]

  let abbr_begin   = '<C-R>=AbbrBegin()<CR>'
  let abbr_end     = '<C-R>=AbbrEnd()<CR>'
  let abbr_jump    = '<C-R>=AbbrJump()<CR>'

  execute("inoreab <buffer> <silent> ".abbr_name." ".abbr_begin.abbr_context.abbr_end)
endfunction


function! AbbrClean()
  let rt = 0
  if exists('b:abbr_lastline') && line('.') == b:abbr_lastline && match(getline('.'),'^\s*$') != -1
    normal! dd
    let rt = 1
  end
  let b:abbr_lastline = 0
  return rt
endfunction


" Map buffer shortcuts, Work with autocmd
function! AbbrInitSyntax()
  execute 'match Comment /'.g:AbbrHintPattern.'/'
endfunction

function! AbbrInitMapKeys()
  inoremap <buffer> <silent> <C-CR> <C-R>=AbbrJump()<CR>
  inoremap <buffer> <silent> <S-CR> <C-R>=AbbrJump()<CR>
  inoremap <buffer> <silent> <ESC> <ESC>:call AbbrClean()<CR>
endfunction


" Map Command
function! AbbrGlobalInit()
  let g:AbbrHintPattern = '\('.join(g:AbbrHint,'\|').'\)'
  command! -nargs=+ Abbr :call AbbrCreate(<q-args>)
  command! -nargs=+ AbbrLoad :call AbbrLoad(<q-args>)
  command! AbbrInitSyntax :call AbbrInitSyntax()
  command! AbbrInitMapKeys :call AbbrInitMapKeys()
  au Syntax,WinEnter * AbbrInitSyntax
  au BufEnter * AbbrInitMapKeys
endfunction


call AbbrGlobalInit()
