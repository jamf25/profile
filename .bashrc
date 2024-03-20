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
###############
# AWS aliases #
###############
# print table of subnets and most relevant info
alias alsubnets="aws ec2 describe-subnets  --query 'Subnets[*].{SubnetId: SubnetId, Name:Tags[?Key==\`Name\`].Value[] | [0],CidrBlock: CidrBlock, VpcId: VpcId, AvailabilityZone: AvailabilityZone}' --output table"
# print table of vpcs and most relevant info
alias alvpcs="aws ec2 describe-vpcs --query 'Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlockAssociationSet[0].CidrBlock,Name:Tags[?Key==\`Name\`].Value[] | [0],CreatedTime:CreatedTime}' --output table"
#alias alvpcs="aws ec2 describe-vpcs --query 'Vpcs[*].{VpcId:VpcId,Name:Tags[?Key==`Name`].Value[] | [0], TagValue:Tags[?Key==\`tagName\`].Value[] | [0]}' --output table "


###############
# git aliases #
###############
# Git Shortcuts
# #####################################

alias diff="git difftool"                                  # Open file in git's default diff tool <file>
alias fetch="git fetch origin"                             # Fetch from origin
alias gamend='git commit --amend'                          # Add more changes to the commit
alias gap='git add -p'                                     # Step through each change
alias gba='git branch -a'                                  # Lists local and remote branches
alias gc="git --no-pager commit"                           # Commit w/ message written in EDITOR
alias gcl='git clone --recursive'                          # Clone with all submodules
alias gcm="git --no-pager commit -m"                       # Commit w/ message from the command line <commit message>
alias gcv="git --no-pager commit --no-verify"              # Commit without verification
alias ginitsubs='git submodule update --init --recursive'  # Init and update all submodules
alias gundo="git reset --soft HEAD^"                       # Undo last commit
alias gs='git --no-pager status -s --untracked-files=all'  # Git status
alias gsearch='git rev-list --all | xargs git grep -F'     # Find a string in Git History <search string>
alias gss='git remote update && git status -uno'           # Are we behind remote?
alias gsubs='git submodule update --recursive --remote'    # Update all submodules
alias gup="git remote update -p; git merge --ff-only @{u}" # Update & Merge
alias undopush="git push -f origin HEAD^:master"           # Undo a git push
alias unstage='git reset HEAD'                             # Unstage a file

# From Git-Extras (https://github.com/tj/git-extras)
alias obliterate='git obliterate'       # Completely remove a file from the repository, including past commits and tags
alias release='git-release'             # Create release commit with the given <tag> and other options
alias rename-branch='git rename-branch' # Rename a branch and sync with remote. <old name> <new name>
alias rename-tag='git rename-tag'       # Rename a tag (locally and remotely). <old name> <new name>
alias ignore='git ignore'               # Add files to .gitignore. Run without arguments to list ignored files.
alias ginfo='git info --no-config'      # Show information about the current repository.
alias del-sub='git delete-submodule'    # Delete a submodule. <name>
alias del-tag='git delete-tag'          # Delete a tag. <name>
alias changelog='git changelog'         # Generate a Changelog from tags and commit messages. -h for help.
alias garchive='git archive'            # Creates a zip archive of the current git repository. The name of the archive will depend on the current HEAD of your git repository.
alias greset='git reset'                # Reset one file to HEAD or certain commit. <file> <commit (optional)>
alias gclear='git clear-soft'           # Does a hard reset and deletes all untracked files from the working directory, excluding those in .gitignore.
alias gbrowse='git browse'              # Opens the current git repository website in your default web browser.
alias gtimes='git utimes'               # Change files modification time to their last commit date.



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

function clean-config () {
  egrep -v '^\s*#|^$' $1
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
