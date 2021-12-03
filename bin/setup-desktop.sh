#!/bin/bash

echo "Setup terminal default profile colors and behavior"

BASE="/org/gnome/terminal/legacy"
PROFILES="$BASE/profiles:"
DEFAULT=`dconf read $BASE/default`

# There appears to be a bug in dconf read, the -d will not return the default
# value if the key is not present, hopefully this value is constant...
if [ -z "$DEFAULT" ]; then
	DEFAULT="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
fi

dconf write $BASE/default-show-menubar false
dconf write $PROFILES/:$DEFAULT/login-shell true
dconf write $PROFILES/:$DEFAULT/use-theme-colors false
dconf write $PROFILES/:$DEFAULT/background-color "'rgb(0,0,0)'"
dconf write $PROFILES/:$DEFAULT/foreground-color "'rgb(255,255,255)'"
dconf write $PROFILES/:$DEFAULT/scrollbar-policy "'never'"
