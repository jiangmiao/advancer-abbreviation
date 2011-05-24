Advancer Abbreviate
==================
Advancer Abbreviate is a Vim plugin to create code snippet

Installation
------------
    copy plugin/advancer-abbreviate.vim to ~/.vim/plugin

Features
--------
###Support any character except space as abb name
    Abbr #i #include </*TODO*/>
    Abbr -> $this->
    all valid.
###Quick Jump To Next Placeholder
###Easy to extend

Usage
-----
    Use Shortcut <C-CR> or <S-CR> to expand the abbreviate or jump to next TODO mark.

Tutorial
--------
###Preparation
    copy ftplugin-examples/* to ~/.vim/ftplugin

    There are 5 examples include c, cpp, javascript, php, ruby
    The abbreviates supported in example are

        c          : for std main #i #ii
        cpp        : for std main
        javascript : for fu
        ruby       : for def
        php        : for

    You could test the script with your favourite language.

###example for edit C file
    $ gvim foo.c

1

    <C-CR> = Control+Return
    | = Cursor postion
    input: #i<C-CR>foo<C-CR>#ii<C-CR>bar<C-CR>
    output:
    #include <foo>
    #include "bar"
    |

2

    input: std<C-CR>
    output:
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    |

3

    input: main<C-CR>
    output:
    int main(int argc, char *argv[])
    {
        |
        return 0;
    }

4

    input: for<C-CR>
    output:
    for (|; /*TODO*/; /*TODO*/) {
      /*TODO*/
    }
    /*TODO*/

5

    input: for<C-CR>int i=0<C-CR>
    output:
    for (int i=0; |; /*TODO*/) {
      /*TODO*/
    }
    /*TODO*/
    

Write Your Own Abbreviates
--------------------------
    Use Command Abbr
    Usage: Abbr [name] [code]
    Example:
    Abbr for for (/*TODO*/; /*TODO*/; /*TODO*/) {<CR>/*TODO*/<CR>}<CR>/*TODO*/
    Abbr #ii #include "/*TODO*/"<CR>

    Abbreviate format is same as vim abbr. see help :abbr
    but AdvAbbr has looser limition on name, it support any character as name except space.
    
    TODO has four different formats
    /*TODO*/, #TODO#, 'TODO', <!--TODO-->
    choose them according to which language is using. 
    for example, /*TODO*/ use for c, cpp, 'TODO' use for ruby

Commands
--------
*   AbbrInitSyntax
    highlight placeholder to the same color as COMMENT
    au Syntax,WinEnter * AbbrInitSyntax

*   AbbrInitMapKeys
    map <C-CR> <S-CR> to expand abbr or jump to next placeholder
    au BufEnter * AbbrInitMapKeys

Map the expand keys
-------------------
eg: map the key to Meta-m(Alt-m)
inoremap <buffer> <silent> <M-m> <ESC>a<C-R>=AbbrJump()<CR>

Others
------
Use pathogen manage the script
see http://www.vim.org/scripts/script.php?script_id=2332

