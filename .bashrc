# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

OS=`uname`
# Mac OS X Overrides
if [ "$OS" == "Darwin" ]; then
	alias htop='sudo htop --sort-key PERCENT_CPU'
	export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
fi

# Git PS1 mess
# Fedora, Debian, and Mac OSX use different locations for the git completion
for C in /etc/bash_completion.d/git /etc/bash_completion.d/git-prompt \
	/usr/local/etc/bash_completion.d/git-completion.bash \
	/usr/share/git-core/contrib/completion/git-prompt.sh; do
	if [ -e "$C" ]; then
		GIT_COMPLETION="$C"
		break
	fi
done
for C in /usr/share/git-core/contrib/completion/git-prompt.sh \
	/usr/lib/git-core/git-sh-prompt \
	/usr/local/etc/bash_completion.d/git-prompt.sh; do
	if [ -e "$C" ]; then
		GIT_PROMPT="$C"
		break
	fi
done

# Provide a dummy __git_ps1, and override with the real one if it exists
function __git_ps1() {
	true
}
if [ -e "$GIT_PROMPT" -a -e "$GIT_COMPLETION" ]; then
	source $GIT_PROMPT
	source $GIT_COMPLETION
fi

# Print the __git_ps1 string unless the git directory is $HOME.
function git_ps1() {
	GD="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ "$GD" != "$HOME" ]; then
	    __git_ps1 ' [%s]'
	fi
}

# If running interactively, then:
if [ -v PS1 ]; then

	# don't put duplicate lines in the history. See bash(1) for more options
	export HISTCONTROL=ignoredups

	# ASCIIbetical sorting for ls, etc.
	export LC_COLLATE=C

	# enable color support of ls and also add handy aliases
	# Not available on Mac:
	#eval `dircolors -b`
	alias ls='ls --color=auto -G'
	#alias ls='ls -G'
	#alias dir='ls --color=auto --format=vertical'
	#alias vdir='ls --color=auto --format=long'

	# some more ls aliases
	#alias ll='ls -l'
	#alias la='ls -A'
	#alias l='ls -CF'

	#don't confuse network connections
	alias ssh='TERM=xterm ssh'

	# shortcut aliases
	alias r='ssh rage'
	alias f='ssh fear'
	alias wut='ssh wut'
	alias rr='tsocks ssh rager'
	alias bb='log bitbake'
	alias cpr='create-pull-request'
	alias spr='send-pull-request'
	alias by='byobu'
	alias rt='rxvt +sb +ls -bg black -fg white -geometry 80x24'

	if [ -n "$(which vimx 2> /dev/null)" ]; then
	    alias vim='vimx'
	fi

	# set a fancy prompt
	# working dir in titlebar
	# 'user@host:basename' dir on the prompt
	# bold green prompt
	#PS1='\u@\h:\w\$ '
	if [ $TERM != "linux" ]; then
	    TITLEBAR="\[\e]2;\w\a\]"
	fi
	GIT_PS1_SHOWDIRTYSTATE=1
	PROMPT="\[\e[32;1m\]\u@\h:\w\$(git_ps1)"
	if [ -v PS1_PREFIX ]; then
		PROMPT2="\[\e[31;1m\]$PS1_PREFIX "
	fi
	PS1="$TITLEBAR$PROMPT\n$PROMPT2$ \[\e[0m\]"

	# If this is an xterm set the title to user@host:dir
	#case $TERM in
	#xterm*)
	#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
	#    ;;
	#*)
	#    ;;
	#esac

	# enable programmable completion features (you don't need to enable
	# this, if it's already enabled in /etc/bash.bashrc).
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi

	# user environment variables
	if [ -x "$(which vimx 2> /dev/null)" ]; then
	    export EDITOR=vimx
	elif [ -x "$(which vim)" ]; then
	    export EDITOR=vim
	else
	    export EDITOR=vi
	fi
	# xterm-16color is horribly broken, searches are invisible in vim, etc etc
	#export TERM=xterm-16color
	export PYTHONSTARTUP=~/.pythonrc

	# Ubuntu doesn't have OSS support
	export QEMU_AUDIO_DRV=alsa

	export JAVA_HOME="/usr/java/latest"

	export QUILT_DIFF_OPTS="-p"
	export QUILT_REFRESH_ARGS="--no-timestamps --backup --diffstat --strip-trailing-whitespace" 

	# use custom vi bindings specified in .bash_bindings
	if [ -e ~/.bash_bindings ]; then
		. ~/.bash_bindings
	fi

	# Intel proxy setup
	#export http_proxy=http://proxy.jf.intel.com:911
	#export https_proxy=https://proxy.jf.intel.com:911
	#export ftp_proxy=http://proxy.jf.intel.com:911
	#export all_proxy=socks://proxy-socks.jf.intel.com:1080/
	#export ALL_PROXY=socks://proxy-socks.jf.intel.com:1080/
	#export no_proxy=".intel.com,otcgit.jf.intel.com"

	# Prepare git to use the proxy
	#export GIT_PROXY_COMMAND=oe-git-proxy

	# Fix proxy problems (see Launchpad bug #554068)
	#export no_proxy=${no_proxy%,}

	# Work around Pidgin-sipe/IT issues
	export NSS_SSL_CBC_RANDOM_IV=0

	# bitbake related environment
	export TEMPLATECONF="/home/jdoe/.bitbake/templateconf"

	# Use gnupg 2.x
	alias gpg=gpg2
	# Make sure gpg2 can prompt for the Yubikey user PIN
	export GPG_TTY=$(tty)
fi
