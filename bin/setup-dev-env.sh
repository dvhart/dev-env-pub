#!/bin/bash

function makedir() {
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
}

function clone_repo() {
	DEST=$1
	shift
	if [ ! -d $DEST ]; then
		git clone $@ $DEST
	else
		echo "Repository $DEST exists, remove and run again to clone"
		return 1
	fi
	return 0
}

#echo "Update base install"
if [ -e /etc/lsb-release ]; then
	DISTRO=$(grep DISTRIB_ID /etc/lsb-release | cut -d = -f 2)
elif [ -e /etc/redhat-release ]; then
	DISTRO=$(cat /etc/redhat-release | cut -d ' ' -f 1)
fi
if [ "$DISTRO" == "Ubuntu" ]; then
	sudo apt update

	echo "Install development packages"
	sudo apt install -y `cat ~/bin/ubuntu-package-list.txt`

	echo "Upgrade and install pip packages"
	pip install --user --upgrade pip
	pip install --user git-pw
elif [ "$DISTRO" == "Fedora" ]; then
	sudo dnf update

	echo "Install development packages"
	sudo dnf install --best --allowerasing -y `cat ~/bin/fedora-package-list.txt`

	echo "Upgrade and install pip packages"
	pip install --user --upgrade pip
	pip install --user git-pw
else
	echo "Unkown DISTRO=$DISTRO, skipping base install"
fi

echo -e "\nPrepare mail and patch environment"
makedir ~/Mail/company
makedir ~/incoming

echo -e "\nInstall crontab"
if [ `crontab -l | wc -l` -eq 0 ]; then
	sudo crontab -u $USER ~/bin/crontab
fi

echo -e "\nSetup tools"
makedir ~/bin
cd ~/bin

echo -e "\nSetting up mirrors"
makedir ~/source/mirror
cd ~/source/mirror
clone_repo linux.git --mirror git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
clone_repo linux-stable.git --mirror --reference linux.git git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
clone_repo linux-next.git --mirror --reference linux.git git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

echo -e "\nSetting up working sources"
makedir ~/source/linux
cd ~/source/linux
clone_repo linux-dev -o linus ~/source/mirror/linux.git
if [ $? -eq 0 ]; then
	cd linux-dev
	git remote add next file://$HOME/source/mirror/linux-next.git
	git remote update
	#git checkout -b for-next pdx86/for-next
	#git checkout -b fixes pdx86/fixes

	# setup patchwork client
	#git config pw.server https://patchwork.kernel.org/api/1.0/
	#git config pw.project platform-driver-x86
	#git config pw.username jdoe
	#git config pw.password XXXXXXXXXXXX
fi

echo -e "\nSetup Desktop"
~/bin/setup-desktop.sh
