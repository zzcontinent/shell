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
	cnt_0=`ps aux | grep netspeed\.sh | grep -v grep | wc -l`
	cnt_1=`ps aux | grep indicator-netspeed | grep -v grep | wc -l`
	if [ $cnt_0 == 0 ];then
		(nohup netspeed.sh >/dev/null 2>&1 >/dev/null&)
	fi

	if [ $cnt_1 == 0 ];then
		(nohup indicator-netspeed >/dev/null 2>&1 >/dev/null&)
	fi
}


txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset
blink='\e[5m'

BLACK="${bldblk}"
RED="${bldred}"
GREEN=${bldgrn}
YELLOW=${bldylw}
BLUE=${bldblu}
PURPLE=${bldpur}
CYAN=${bldcyn}
WHITE=${bldwht}
DONE=${txtrst}

func_ps1_basic()
{
	if [ "x$(whoami)" == "xroot" ];then
		[ ! -z "${SSH_CLIENT}" ] && printf "${RED}[%s %d %s]" $(whoami) $(who|wc -l) $(echo "${SSH_CLIENT}"|awk '{print $1}')
		[ -z "${SSH_CLIENT}" ] && printf "${RED}[%s %d]" $(whoami) $(who|wc -l)
		printf "[%.1f %.1fd" $(cut -d' ' -f1 /proc/loadavg)  $(echo "scale=2;$(cut -d' ' -f1 /proc/uptime)/86400" |bc)
		tmp_netspeed="$(cat ${HOME}/.tmp_netspeed 2>/dev/null|awk '{print $4}'|sort -rn| head -n1)"
		[ ! -z ${tmp_netspeed} ] && printf " %s" ${tmp_netspeed}
		printf ']'
		printf "[%s %s]"  $(date "+%m-%d %H:%M:%S")
	else
		[ ! -z "${SSH_CLIENT}" ] && printf "${GREEN}[%s %d %s]" $(whoami) $(who|wc -l) $(echo "${SSH_CLIENT}"|awk '{print $1}')
		[ -z "${SSH_CLIENT}" ] && printf "${GREEN}[%s %d]" $(whoami) $(who|wc -l)
		printf "${YELLOW}[%.1f %.1fd" $(cut -d' ' -f1 /proc/loadavg)  $(echo "scale=2;$(cut -d' ' -f1 /proc/uptime)/86400" |bc)
		tmp_netspeed="$(cat ${HOME}/.tmp_netspeed 2>/dev/null|awk '{print $4}'|sort -rn| head -n1)"
		[ ! -z ${tmp_netspeed} ] && printf " %s" ${tmp_netspeed}
		printf ']'
		printf "${CYAN}[%s %s]"  $(date "+%m-%d %H:%M:%S")
	fi
}

func_ps1_git()
{
	gitb=$(git branch --show-current 2>/dev/null)
	[ ! -z ${gitb} ] && gitb="(${gitb})" && printf "${RED}${gitb}"
}

func_ps1_result()
{
	ret=$?
	if [ $ret != 0 ];then
		printf "${RED}($ret)"
	else
		printf "${GREEN}($ret)"
	fi
}

if [ "$color_prompt" = yes ]; then
	PS1="${debian_chroot:+($debian_chroot)}\$(func_ps1_result)\$(func_ps1_basic)${BLUE}:[\w]\$(func_ps1_git)${DONE}\n$ "
else
	BLACK=
	RED=
	GREEN=
	YELLOW=
	BLUE=
	PURPLE=
	CYAN=
	WHITE=
	DONE=
	PS1="${debian_chroot:+($debian_chroot)}\$(func_ps1_basic)${BLUE}:[\w]\$(func_ps1_git)${DONE}\n\$ "
fi

unset color_prompt force_color_prompt

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
export PATH=$PATH:/home/cliff/shell:/usr/local/go/bin
#export http_proxy='http://172.17.0.72:1081'
#export https_proxy='http://172.17.0.72:1081'
#export ANDROID_NDK_HOME='/home/cliff/data/software/android-ndk-r21'

grepl()
{
	grep -rn $@ --color=always 2>/dev/null | less -r
}

findl()
{
	find | grep $@ --color=always 2>/dev/null | less -r
}

grepn()
{
	grep -rn $@ --color=always 2>/dev/null
}

findn()
{
	find | grep $@ --color=always 2>/dev/null
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

psg() {
	[ ! -z $1 ] && ps auxf 2>&1 | grep $1 && return 0
	ps auxf 2>&1
}

psgl() {
	[ ! -z $1 ] && ps auxf 2>&1 | grep $1 | less -N && return 0
	ps auxf 2>&1 | less -N
}

ts() {
	cp $1 $1_`date "+%y%m%d_%H%M%S"`
}

tsmv() {
	mv $1 $1_`date "+%y%m%d_%H%M%S"`
}

lessc() {
	if [ ! -z $1 ];then
		cat $1 | highlight -O ansi --syntax c| less -R
		return 0
	fi
	highlight -O ansi --syntax c | less -R
}

cf() {
	if [ ! -z $1 ];then
		cat $1  > ~/.vim.cf
		return 0
	fi
	cat > ~/.vim.cf
}

cv() {
	cat ~/.vim.cf
}

md() {
	if [ ! -z $1 ];then
		markdown-it  $1| w3m -T text/html
		return 0;
	fi
}

mdf() {
	if [ ! -z $1 ];then
		markdown-it  $1 > $1.html
		return 0;
	fi
}

alias gitl='git log --graph --date=iso8601'
alias gitls='git log --graph --date=iso8601 --stat'
alias gitlo='git log --graph --pretty=oneline --date=iso8601'
alias gitlos='git log --graph --pretty=oneline --date=iso8601 --stat'
alias gitla='git log --graph --all --date=iso8601'
alias gitlas='git log --graph --all --date=iso8601 --stat'
alias gitlao='git log --graph --all --pretty=oneline --date=iso8601'
alias gitlaos='git log --graph --all --pretty=oneline --date=iso8601 --stat'

alias gitsl='git log --date=iso8601'
alias gitsls='git log --date=iso8601 --stat'
alias gitslo='git log --pretty=oneline --date=iso8601'
alias gitslos='git log --pretty=oneline --date=iso8601 --stat'
alias gitsla='git log --all --date=iso8601'
alias gitslas='git log --all --date=iso8601 --stat'
alias gitslao='git log --all --pretty=oneline --date=iso8601'
alias gitslaos='git log --all --pretty=oneline --date=iso8601 --stat'

alias gitst='git status'
alias gitsh='git show'
alias gitshs='git show --stat'
alias gitd='git diff'
alias gitds='git diff --stat'
alias gitdt='git difftool --tool=vimdiff'
alias gitb='git branch --all'

cd_func()
{
	cd $1
	ls -alhF `pwd`
}

#alias cd='cd_func'
alias cdpi='cd /home/backup/pi'
alias dfh='df -Th'

alias delugec='deluge-console 2>/dev/null'
alias gitps='git push'
alias gitpl='git pull'

alias cdt='cd ~/toyos/src'
alias sortf='find -type f | xargs wc 2>/dev/null | sort -n | less -N'
alias j='jobs'

start_netspeed
alias r='ranger'
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#riscv
alias cdrv='cd /home/cliff/rvworkspace/native/'
alias source_toolchain_rv='export PATH=/home/cliff/rvworkspace/native/riscv-gnu-toolchain/out/bin:${PATH}'
#export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#
alias wine_aliyun='wine ~/.wine/drive_c/users/cliff/AppData/Local/Programs/aDrive/aDrive.exe'
alias cdwine='cd ~/.wine/drive_c/'
alias exportcn='export LANG=zh_CN.UTF-8 GDM_LANG=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8'
