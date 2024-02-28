# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#fzf goodness
source ~/.fzf.bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Alias definitions.
# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'


alias bshedit="vim ~/.bash_profile"
alias webgo="python3 -m http.server 80"
alias nseq="ls -l /usr/share/nmap/scripts | grep -i "

alias shz="grep bash /doc/custom"
alias htbvpn='openvpn /home/omega/vpn/htb.ovpn'
alias mkvpn='vim /home/omega/vpn/htb.ovpn'
alias pmap='proxychains -q nmap -sT -Pn'
alias nmap='nmap --stylesheet "https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl"'
alias qmap='nmap --top-ports=150 -T4'
alias fullmap='nmap -T4 -sC -sV -O'
alias pffuf='ffuf -x http://localhost:8080'
alias t1ip="ip ad l tun0 | grep inet\  | awk '{split($0,a,\" \"); split(a[2],b,\"/\");print b[1]}'"
alias rfuf='ffuf -w /wordlists/dirb/small.txt -recursion -recursion-depth 2 -e .txt,.bak,.php,.htm,.html'
alias qfuf='ffuf -w /NI'
alias xfuf='ffuf -w /wordlists/dirb/small.txt -e .txt,.bak,.php,.htm,.html'
alias bfuf='ffuf -w /ulist/common-admins.txt:UFUZZ -w /plist/quick_win_passwords.txt:PFUZZ'
#make postdata fuffy
#try fix this
#http://192.168.202.93/system/resources/readme.txt
#for gettings ports from nmap.xml
alias portsplz="grep -oE --color 'portid=\"[[:digit:]]+\"'"
alias quickwin="medusa -f -O medusa.log -U /ulist/top-usernames-shortlist.txt -P /plist/quick_win_passwords.txt -t 10"
alias portmap="nmap -p- -oN allports"
alias http-map="nmap --script \"http-* and safe and not brute\""


#testing area
# cat allports |grep ^[[:digit:]] |  awk -F\/ '{print $1}' | tr '\n' ',' 1 | cut -d' ' -f 2
#alias  grep -o Ports.* ports | grep -oE [[:digit:]]+/open |  tr -d '\r\n' | sed 's/\/open/,/g' | sed 's/.$//'


# template for doing jq stuff            string intrepidation? lol
#jsearch="jq -r  '.RESULTS_EXPLOIT[]| "\(.Date) \(.Path) \(.Title)"'"





##################
#custom functions#
##################

# how to get docs too? maybe set var and reference twice with jc?
function jsearch(){				#      reset term color  tab  have to quote '-'   term color red
  searchsploit $@ -j | jq -C -r  '.RESULTS_EXPLOIT[]| "\u001b[0m \(.Date) \t \(."EDB-ID")  \t \u001b[33m \(.Title)"' | sort
}

function mknames(){
  usernamer.py -f $1 -p dotted_two_terms,one_term,normal_abbreviated | grep -v '^..$'
}

function getss(){
  if [ -z "$1" ]; then
    echo "need arg fool."
  else 
    find ~/Pictures/ -maxdepth 1 -iname "*.png" -exec cp {} ~/Pictures/bak/$1 \; -exec mv {} ./$1.png \;
  fi
}


# pull urls from ffuf output
function jfuf() {
  cat $1 | jq '.results[]| "\(.status) \(.url)"'
}


#curl each url in a ffuf output for commend (or just keywords)

function curfuf() {
  for i in `ls | grep bust`; do
    for c in `jfuf $i | cut -d" " -f2`; do  
      url=`echo $c | tr -d \"`
      curl -L -k -s $url | grep -i $1
    done
  done
}

# You may want to put all your additions into a separate file like
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTIGNORE="history:ls:pwd:cd"
#http_proxy=http://127.0.0.1:8088

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2500
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
