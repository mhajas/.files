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

pacmanDeps=$(cat $DIR/*/dependencies | sort | uniq | grep -Ev '^(aur|synaptiko)/' | sort | xargs)
aurDeps=$(cat $DIR/*/dependencies | sort | uniq | grep '^aur/' | cut -d'/' -f2 | grep -E -v '^(yay-bin)$' | sort | xargs)

if [ "$onlyMissing" = true ]; then
	pacmanDeps=$(pacman -T $pacmanDeps | xargs)
	aurDeps=$(pacman -T $aurDeps | xargs)
	synaptikoDeps=$(pacman -T $synaptikoDeps | xargs)
fi

if [ "$pacmanDeps" != "" ]; then
	echo -e "\e[1msudo pacman -S \e[0m$pacmanDeps"
	if [ "$dryRun" != true ]; then
		sudo pacman -S $pacmanDeps
	fi
fi

if [ "$aurDeps" != "" ]; then
	echo -e "\e[1myay -S \e[0m$aurDeps"
	if [ "$dryRun" != true ]; then
		yay -S $aurDeps
	fi
fi