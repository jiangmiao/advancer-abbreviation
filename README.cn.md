Advancer Abbreviation
=====================
Advancer Abbreviation 是一个用于创建代码片断的VIM插件

特性
--------
*   支持除空白外任意字符作为名称
*   快速跳转到下一个代码点
*   方便扩展

安装
------------
    复制 plugin/advancer-abbreviation.vim 到 ~/.vim/plugin

使用
-----
    使用 <C-CR> 或 <S-CR> 展开或跳转

教程
--------
###准备
    复制 ftplugin-examples/* 到 ~/.vim/ftplugin

    这里有5个例子文件包括c, cpp, javascript, php, ruby
    以下是每种文件包含的缩略词

        c          : for std main #i #ii
        cpp        : for std main
        javascript : for fu
        ruby       : for def
        php        : for

    可以选择一个熟悉的语言作测试

###example for edit C file
    <C-CR> = Control+Return
    |      = 光标位置
    $ gvim foo.c

1

    输入: #i<C-CR>foo<C-CR>#ii<C-CR>bar<C-CR>
    输出:
    #include <foo>
    #include "bar"
    |

2

    输入: std<C-CR>
    输出:
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    |

3

    输入: main<C-CR>
    输出:
    int main(int argc, char *argv[])
    {
        |
        return 0;
    }

4

    输入: for<C-CR>
    输出:
    for (|; /*TODO*/; /*TODO*/) {
      /*TODO*/
    }
    /*TODO*/

5

    输入: for<C-CR>int i=0<C-CR>
    输出:
    for (int i=0; |; /*TODO*/) {
      /*TODO*/
    }
    /*TODO*/
    

编写缩写
---------------------------
    命令: Abbr [name] [code]
    例:
    Abbr for for (/*TODO*/; /*TODO*/; /*TODO*/) {<CR>/*TODO*/<CR>}<CR>/*TODO*/
    Abbr #ii #include "/*TODO*/"<CR>

    Abbr内容格式和vim自带的abbr基本一样.
    但是 Advancer Abbreviation 有更宽松的名字限定,
    比如f.f在vim abbr中是不合法的,而在这里是合法的
    
    TODO 有四种格式
    /*TODO*/, #TODO#, 'TODO', <!--TODO-->
    根据使用的场合不同选则不同
    比如, /*TODO*/ 用于 c, cpp, 'TODO' 用于 ruby

重新定制快捷键
---------------------------
    如果C-CR或S-CR有其它用途，在.vimrc中加入 
    let g:AbbrPredefinedShortcuts = 0
    禁止脚本对C-CR于S-SR进行map
    再加入
    inoremap <buffer> <silent> <M-m> <ESC>a<C-R>=AbbrJump()<CR>
    绑定展开动作到Alt-m键。<M-m>可以改成任何键。


问题
---------------
####插件不能工作
    1、检查按键是否映射正确
    use :imap <C-CR> to check if the key binds correct.
    The correct 输出 should be
    i   <C-CR>    *@<ESC>a<C-R>=AbbrJump()<CR>

    2、终端是否支持相应的快捷键。
    比如有的终端不对持<C-CR>，有的不支持Alt。

其它
------
    用 pathogen 可以更方便的管理脚本
    见 http://www.vim.org/scripts/script.php?script_id=2332
