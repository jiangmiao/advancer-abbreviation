" Maintainer: Miao Jiang <jiangfriend@gmail.com>
" Last Change: 2011-5-18
" Version: 1.0
" Homepage:
" Repository:

if exists('g:AbbrLoaded')
  finish
end
let g:AbbrLoaded = 1

if !exists('g:AbbrHint')
  let g:AbbrHint = ['/\*TODO\*/','#TODO#', ';TODO;', '<!--TODO-->']
end
let g:Abbrs = {}
let s:is_block = 0
function! AbbrJump()
  " expand abbr if abbr is valid.
  let @p=''

  let is_eol=0
  if col('$') - col('.') <= 1
    let is_eol=1
  else
    execute 'normal h'
  end
  normal "Pdiw
  if @p!=''
    if has_key(g:Abbrs, @p)
      execute "normal aabbr_".@p
    else
      if is_eol
        execute 'normal a'.@p
      else
        execute 'normal i'.@p
      end
    end

  end

  let start=line("'P")
  if start == 0 || start > line('$')
    return
  end

  " Jump to TODO block
  let i = 0
  while i < len(g:AbbrHint)
    let hint = g:AbbrHint[i]
    if search(hint,'W') 
      let s:is_block = 1
      execute 'normal df'.hint[-1:]
      return
    end
    let i = i + 1
  endwhile

  if start == line('.') && line('.') != line('`Q')
    normal `Q
  end
endfunction


function! AbbrBegin()
  let s:is_block = 1
  normal mP
endfunction

function! AbbrEnd()
  normal mQ
  normal `P
endfunction

function! CreateAbbr(args)
  let args = matchlist(a:args, '^\s*\(.\{-}\)\s\+\(.*\)$')
  if len(args) == 0
    return
  end

  let abbr_name    = args[1]

  if abbr_name == ''
    return
  end

  " Store abbr_name index to Abbrs
  let g:Abbrs[abbr_name] = 1
  let abbr_name = 'abbr_'.abbr_name

  let abbr_context = args[2]

  let abbr_begin   = '<C-O>:call AbbrBegin()<CR>'
  let abbr_end     = '<C-O>:call AbbrEnd()<CR>'
  let abbr_jump    = '<C-O>:call AbbrJump()<CR>'

  execute("inoreab ".abbr_name." ".abbr_begin.abbr_context.abbr_end)
endfunction

command! -nargs=+ Abbr :call CreateAbbr(<q-args>)
command! AbbrJump :call AbbrJump()
imap <C-CR> <ESC>:call AbbrJump()<CR>a

