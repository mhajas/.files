#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for arg in $@; do
	case "$arg" in
		--dry-run|-d)
			dryRun=true
			;;
		--only-missing|-o)
			onlyMissing=true
			;;
	esac
done

pacmanDeps=$(cat $DIR/*/dependencies | sort | uniq | xargs)

if [ "$onlyMissing" = true ]; then
	pacmanDeps=$(pacman -T $pacmanDeps | xargs)
fi

if [ "$pacmanDeps" != "" ]; then
	echo -e "\e[1msudo apt-get install \e[0m$pacmanDeps"
	if [ "$dryRun" != true ]; then
		sudo apt-get install $pacmanDeps
	fi
fi