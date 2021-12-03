#!/bin/bash

MIRRORS="$HOME/source/mirror/"

date

cd $MIRRORS
for R in *.git; do
	echo -n "Updating $R..."
	cd $R
	git fetch --tags &> /dev/null
	if [ $? -eq 0 ]; then
		echo "Done"
	else
		echo "ERROR"
	fi
	cd $MIRRORS
done
