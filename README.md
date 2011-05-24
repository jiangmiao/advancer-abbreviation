Advancer Abbreviation
=====================
Advancer Abbreviation is a Vim plugin to create code snippet quickly

Features
--------
*   Support any character except space as abbreviate name.
*   Quick jump to next placeholder.
*   Easy to extend.

Installation
------------
    copy plugin/advancer-abbreviate.vim to ~/.vim/plugin

Usage
-----
    Use Shortcut <C-CR> or <S-CR> to expand the abbreviate or jump to next placeholder.

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
    <C-CR> = Control+Return
    |      = Cursor postion
    $ gvim foo.c

1

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
    

Write Your Own Abbreviation
---------------------------
    Use Command Abbr
    Usage: Abbr [name] [code]
    Example:
    Abbr for for (/*TODO*/; /*TODO*/; /*TODO*/) {<CR>/*TODO*/<CR>}<CR>/*TODO*/
    Abbr #ii #include "/*TODO*/"<CR>

    Abbreviate format is same as vim abbr. see help :abbr
    but AdvAbbr has looser limition on name, it support any character as name except space.
    eg: f.f is invalid name in vim abbr but valid in Advancer Abbreviation.
    
    TODO has four different formats
    /*TODO*/, #TODO#, 'TODO', <!--TODO-->
    choose them according to which language is using. 
    for example, /*TODO*/ use for c, cpp, 'TODO' use for ruby

Map the expand and jump key
---------------------------
    map the expand and jump key to Meta-m(Alt-m)
    inoremap <buffer> <silent> <M-m> <ESC>a<C-R>=AbbrJump()<CR>


TroubleShooting
---------------
####The plugin cannot work.
    use :imap <C-CR> to check if the key binds correct.
    The correct output should be
    i   <C-CR>    *@<ESC>a<C-R>=AbbrJump()<CR>

Others
------
    Use pathogen manage the abbreviation script easily
    see http://www.vim.org/scripts/script.php?script_id=2332
