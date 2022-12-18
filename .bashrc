# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
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

start_netspeed()
{
	cnt_0=`ps aux | grep netspeed.sh | grep -v grep | wc -l`
	cnt_1=`ps aux | grep indicator-netspeed | grep -v grep | wc -l`
	[ $cnt_0 == 0 ] && (nohup netspeed.sh >/dev/null 2>&1 &)
	[ $cnt_1 == 0 ] && (nohup indicator-netspeed >/dev/null 2>&1 &)
}

start_netspeed

basic_info()
{
	printf '[%.2f_%.2f_%s][%s]' $(cut -d' ' -f1 /proc/loadavg)  $(echo "scale=2;$(cut -d' ' -f1 /proc/uptime)/86400" |bc)  $(cat /run/user/$(id -u)/.tmp_netspeed|awk '{print $4}'|sort -rn| head -n1) $(date +%m%d_%H%M)
}

if [ "$color_prompt" = yes ]; then
	PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\][\u:\$(who|wc -l)]\[\033[00m\]\[\033[31;1m\]\$(basic_info)\[\033[00m\]:\[\033[01;34m\][\w]\[\033[00m\]\$ "
fi
if [ ${USER} == root ];then
	PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\][\u:\$(who|wc -l)]\[\033[00m\]\[\033[31;1m\]\$(basic_info)\[\033[00m\]:\[\033[01;34m\][\w]\[\033[00m\]\$ "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\][\u:\$(who|wc -l)]\[\033[00m\]\[\033[31;1m\]\$(basic_info)\[\033[00m\]:\[\033[01;34m\][\w]\[\033[00m\]\$ "
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

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ll'
#alias rm='rm -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
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
# export GOPATH="/home/cliff/goworkspace"
# export GOROOT="/home/cliff/data/software/go"
# export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
export PATH=$PATH:/home/cliff/shell
#export http_proxy='http://172.17.0.72:1081'
#export https_proxy='http://172.17.0.72:1081'
export ANDROID_NDK_HOME='/home/cliff/data/software/android-ndk-r21'

grepl()
{
	grep -rn $@ --color=always | less -N -r
}

findl()
{
	find | grep $@ --color=always | less -N -r
}

treel()
{
	cmd='tree -C'
	[ ! -z $1 ] && cmd+=" -L $1 "
	[ ! -z $2 ] && cmd+=" $2"
	(eval $cmd) | less -N -r
}

dul()
{
	cmd='du -ah'
	args=($@)
	[ ! -z $1 ] && cmd+=" --max-depth=$1 "
	[ ! -z $2 ] && unset args[0] && cmd+=" ${args[@]} "
	(eval $cmd) | less -N -r
}

duls()
{
	cmd='du -ah'
	args=($@)
	[ ! -z $1 ] && cmd+=" --max-depth=$1 "
	[ ! -z $2 ] && unset args[0] && cmd+=" ${args[@]} "
	(eval $cmd) | sort -g | less -N -r
}

gitamend()
{
	git add .
	git commit --amend --no-edit
}

alias gitl='git log --graph'
alias gitla='git log --graph --all'
alias gitst='git status'
alias gitsh='git show'
alias gitshs='git show --stat'
alias gitd='git diff'
alias gitds='git diff --stat'
alias gitdt='git difftool --tool=vimdiff'
alias gitb='git branch --all'

alias myc='tee ~/tmp/.myclip'
alias myv='cat ~/tmp/.myclip'
alias cdpi='cd /home/backup/pi'
alias dfh='df -h | less'

alias delugec='deluge-console 2>/dev/null'

psg()
{
	[ ! -z $1 ] && ps auxf 2>&1 | grep $1 && return 0
	ps auxf 2>&1
}

psgl()
{
	[ ! -z $1 ] && ps auxf 2>&1 | grep $1 | less -N && return 0
	ps auxf 2>&1 | less -N
}

ts()
{
	cp $1 $1_`date "+%y%m%d_%H%M%S"`
}
