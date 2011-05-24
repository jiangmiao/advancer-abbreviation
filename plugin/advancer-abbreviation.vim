" Advancer Abbreviate
" Maintainer: Miao Jiang <jiangfriend@gmail.com>
" Last Change: 2011-5-24
" Version: 1.0.1
" Homepage: http://www.vim.org/scripts/script.php?script_id=3598
" Repository: https://github.com/jiangmiao/advancer-abbreviation

if exists('g:AbbrLoaded') || &cp
  finish
end

let g:AbbrLoaded = 1

if !exists('g:AbbrPlaceholders')
  let g:AbbrPlaceholders = ['\/\*TODO\*\/','#TODO#', "'TODO'", '<!--TODO-->']
end

" Autocmd
if !exists('g:AbbrAutoInit')
  let g:AbbrAutoInit = 1
end

if !exists('g:AbbrShortcutEscape')
  let g:AbbrShortcutEscape      = ['<ESC>']
end

if !exists('g:AbbrShortcutExpand')
  let g:AbbrShortcutExpand = ['<C-CR>', '<S-CR>']
end


let g:Abbrs                   = {}
let g:AbbrPlaceholdersPattern = ''
let g:AbbrPrefix              = 'advabbr_'
let g:AbbrPattern             = '\S\+'

function! AbbrWordReplace(word)
  return 'Z'.char2nr(a:word).'Z'
endfunction
function! AbbrWord(str)
  return substitute(a:str, "[^a-zA-Y0-9_]",'\=AbbrWordReplace(submatch(0))','g')
endfunction

function! AbbrJump()
  let is_eol = 0
  let eol    = col('.')
  let right  = eol - 1

  if col('$') == col('.')
    let is_eol=1
  else
    normal h
  end

  " Expand abbreviation
  if right == 0
    let word = ''
  else
    let left = right - 20
    if left < 0
      let left = 0
    end
    let word = AbbrWord(matchstr(getline('.')[  left : right - 1 ], g:AbbrPattern.'$'))
    let len  = len(word)
    let i    = 0
    while i<len
      if has_key(g:Abbrs, word[ i : ])
        let word = word[ i : ]
        break
      end
      let i = i+1
    endwhile

    if i == len
      let word = ''
    end
  end


  if word != ''
    let rword = substitute(word,'Z\d\+Z',"x",'g')
    let rword = substitute(rword,".","x",'g')
    let len   = len(rword) - 1
    let cmd   = ''
    if len > 0
      let cmd = len.'X'
    end
    
    " Output abbreviaton
    execute "normal ".cmd.'cl'.g:AbbrPrefix.word
  end

  let start=line("'p")

  " Jump to placeholder
  let i = 0
  let cleaned = AbbrClean()
  if search(g:AbbrPlaceholdersPattern,'W') 
    let hint            = matchlist(getline('.'), g:AbbrPlaceholdersPattern, col('.')-1)[0]
    let b:abbr_lastline = line('.')
    " Add ; to avoid vim clean the empty line
    execute 'normal! cf'.hint[-1:].';'
    return "\<Del>"
  else
    if cleaned
      normal I;
      return "\<DEL>"
    end
  end


  if line("'q")>0 && line("'q")<=line('$')
    normal! `q
    if !is_eol
      return ""
    end
  end

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
  let args = matchlist(a:args, '^\s*\(.\{-1,}\)\s\+\(.*\)$')
  if len(args) == 0
    echoe 'invalid advancer abbr '.a:args
  end

  let abbr_name          = AbbrWord(args[1])
  let g:Abbrs[abbr_name] = 1
  let abbr_name          = g:AbbrPrefix.abbr_name

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
  execute 'match Comment /'.g:AbbrPlaceholdersPattern.'/'
endfunction

function! AbbrInitMapKeys()

  " Use <ESC>a to avoid E523 main<C-n><C-CR> cause E523
  if type(g:AbbrShortcutExpand) != type([])
    let keys = [g:AbbrShortcutExpand]
  else
    let keys = g:AbbrShortcutExpand
  end
  for key in keys
    execute('inoremap <buffer> <silent> '.key.' <ESC>a<C-R>=AbbrJump()<CR>')
  endfor

  if type(g:AbbrShortcutEscape) != type([])
    let keys = [g:AbbrShortcutEscape]
  else
    let keys = g:AbbrShortcutEscape
  end
  for key in keys
    execute('inoremap <buffer> <silent> '.key.' <C-O>:call AbbrClean()<CR><ESC>')
  endfor
endfunction


" Map Command
function! AbbrGlobalInit()
  let g:AbbrPlaceholdersPattern = '\('.join(g:AbbrPlaceholders,'\|').'\)'
  command! AbbrInitSyntax :call AbbrInitSyntax()
  command! AbbrInitMapKeys :call AbbrInitMapKeys()

  command! -nargs=+ Abbr :call AbbrCreate(<q-args>)

  if g:AbbrAutoInit
    au Syntax,WinEnter * AbbrInitSyntax
    au BufRead,BufNewFile * AbbrInitMapKeys
  end
endfunction


call AbbrGlobalInit()
