Advancer Abbreviate
==================
Advancer Abbreviate is a Vim plugin to create code snippet

Installation
------------
    copy plugin/advancer-abbreviate.vim to ~/.vim/plugin

Usage
-----
    Use Shortcut <C-CR> to expand abbreviate or jump to next TODO mark.

Tutorial
--------
###prepare
    copy ftplugin-examples/* to ~/.vim/ftplugin
    There are 5 examples include c, cpp, javascript, php, ruby
    The abbreviates supported are

    c: std main for
    cpp: std main for
    javascript: fu for
    php: for
    ruby: def for

    You could test the script with your favourite language.

###edit C file
    $ gvim foo.c

1

    input: std<C-CR>
    output:
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
2

    input: main<C-CR>
    output:
    int main(int argc, char *argv[])
    {
        |
        return 0;
    }
3

    input: for<C-CR>
    output:
	for (|; /*TODO*/; /*TODO*/) {
		/*TODO*/
	}
	/*TODO*/
4

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

    Abbreviate format is same as vim abbr. see help :abbr
    the abbrviate name only could be [0-9_a-z]+(numeric _ alpha)
    
    TODO has four different formats
    /*TODO*/, #TODO#, 'TODO', <!--TODO-->
    choose them according to which language is using. 
    for example, /*TODO*/ use for c, cpp, 'TODO' use for ruby
