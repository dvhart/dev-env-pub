# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/bin/pdx86

export PATH

# Company networking looks broken to evolution for some reason
# force it to start online
GIO_USE_NETWORK_MONITOR=base
export GIO_USE_NETWORK_MONITOR

# PDX86 Maintainer ID
export PDX86_ID="jdoe"

