" Advancer Abbreviate
" Maintainer: Miao Jiang <jiangfriend@gmail.com>
" Last Change: 2011-6-08
" Version: 1.0.3
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

" Will not expand bar in foo.bar
if !exists('g:AbbrShortcutSmartExpand')
  let g:AbbrShortcutSmartExpand = ['<S-CR>']
end

" Will expand bar in foo.bar
if !exists('g:AbbrShortcutForceExpand')
  let g:AbbrShortcutForceExpand = ['<C-CR>']
end

if !exists('g:AbbrShortcutNoExpand')
  let g:AbbrShortcutNoExpand = []
end


let g:AbbrPlaceholdersPattern = ''
let g:AbbrPrefix              = 'advabbr_'
"Strict mode
"let g:AbbrPattern             = '[a-zA-Z0-9_#\$]\+'
let g:AbbrPattern             = '\S\+'

" Use for Smartexpand, make foo(bar try to match foo(bar and bar
if !exists('g:AbbrSplitPattern')
  let g:AbbrSplitPattern         = '[()\[\]{}]'
end

function! AbbrWordReplace(word)
  return 'Z'.char2nr(a:word).'Z'
endfunction
function! AbbrWord(str)
  return substitute(a:str, "[^a-zA-Y0-9_]",'\=AbbrWordReplace(submatch(0))','g')
endfunction

let s:NoExpand    = 0
let s:SmartExpand = 1
let s:ForceExpand = 2


" mode = 0 normal, 1 force 2 no
function! AbbrDoExpand(mode)
  let is_eol = 0
  let eol    = col('.')
  let right  = eol - 1

  if col('$') == col('.')
    let is_eol=1
  else
    normal h
  end

  " Expand abbreviation
  if a:mode != s:NoExpand && right != 0
    let left = right - 20
    if left < 0
      let left = 0
    end
    if a:mode == s:SmartExpand
      let splite_pattern = g:AbbrSplitPattern
    else
      let splite_pattern = '[^a-zA-Z0-9_]'
    end

    if a:mode == s:SmartExpand || a:mode == s:ForceExpand
      " Smart and ForceExpand"{{{
      let word  = matchstr(getline('.')[  left : right - 1 ], g:AbbrPattern.'$')
      let words = split(word, splite_pattern.'\zs')
      let len = len(words)

      let i     = 0
      while i<len
        let word = AbbrWord(join(words[ i : ],''))
        if has_key(b:Abbrs, word)
          break
        end
        let i = i+1
      endwhile

      if i == len
        let word = ''
      end
      "}}}
    else
      " Fully Force Expand not in using"{{{
      " Force Expand Everything, Current not used std.main will
      " try std.main td.main d.main .main main ain in n
      let word = AbbrWord(matchstr(getline('.')[  left : right - 1 ], g:AbbrPattern.'$'))
      let len  = len(word)
      let i    = 0
      while i<len
        if has_key(b:Abbrs, word[ i : ])
          let word = word[ i : ]
          break
        end
        let i = i+1
      endwhile

      if i == len
        let word = ''
      end
      "}}}
    end
  else
    let word=''
  end


  " Expand the abbreviation "{{{
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
"}}}

  " Jump to next placeholder
  let i = 0
  let cleaned = AbbrClean()
  " Search current line if start with placeholders
  let hint    = matchstr(getline('.'), '^\s*'.g:AbbrPlaceholdersPattern)
  if hint!='' || search(g:AbbrPlaceholdersPattern,'W') 
    if hint==''
      let hint  = matchstr(getline('.'), g:AbbrPlaceholdersPattern, col('.')-1)
    end
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

  " placeholder is not found
  if line("'q")>0 && line("'q")<=line('$') && line('.') != line("'q")
    normal! `q
    delmark q
    if !is_eol
      return ""
    end
  end

  return "\<Right>"
endfunction

function! AbbrSmartExpand()
  let rt= AbbrDoExpand(s:SmartExpand)
  return rt
endfunction

function! AbbrForceExpand()
  return AbbrDoExpand(s:ForceExpand)
endfunction

function! AbbrNoExpand()
  return AbbrDoExpand(s:NoExpand)
endfunction

function! AbbrBegin()
  mark p
  return ''
endfunction

function! AbbrEnd()
  normal! mq`p
  return "\<Right>"
endfunction

function! AbbrCreate(args)
  let args = matchlist(a:args, '^\s*\(.\{-1,}\)\s\+\(.*\)$')
  if len(args) == 0 || match(args[1], g:AbbrPattern) == -1
    echoe 'invalid advancer abbr '.a:args
  end

  let abbr_name          = AbbrWord(args[1])
  if !exists('b:Abbrs')
    let b:Abbrs = {}
  end
  let b:Abbrs[abbr_name] = 1
  let abbr_name          = g:AbbrPrefix.abbr_name

  let abbr_context = args[2]

  let abbr_begin   = '<C-R>=AbbrBegin()<CR>'
  let abbr_end     = '<C-R>=AbbrEnd()<CR>'
  let abbr_jump    = '<C-R>=AbbrSmartExpand()<CR>'

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

function! s:AbbrArray(ob)
  if type(a:ob) != type([])
    let keys = [a:ob]
  else
    let keys = a:ob
  end
  return keys
endfunction
function! AbbrInitMapKeys()

  " Use <ESC>a to avoid E523 main<C-n><C-CR> cause E523
  for key in s:AbbrArray(g:AbbrShortcutNoExpand)
    execute('inoremap <buffer> <silent> '.key.' <ESC>a<C-R>=AbbrNoExpand()<CR>')
  endfor

  for key in s:AbbrArray(g:AbbrShortcutSmartExpand)
    execute('inoremap <buffer> <silent> '.key.' <ESC>a<C-R>=AbbrSmartExpand()<CR>')
  endfor

  for key in s:AbbrArray(g:AbbrShortcutForceExpand)
    execute('inoremap <buffer> <silent> '.key.' <ESC>a<C-R>=AbbrForceExpand()<CR>')
  endfor

  for key in s:AbbrArray(g:AbbrShortcutEscape)
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
    au BufRead,BufNewFile,BufCreate * AbbrInitMapKeys
  end
endfunction


call AbbrGlobalInit()
