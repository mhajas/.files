#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$USER" == "root" ]; then
	mkdir -p ~/.files
	ln -s -f $DIR ~/.files
else
	sudo ln -s -f $DIR/reflector.service /etc/systemd/system/reflector.service
	sudo mkdir -p /etc/pacman.d/hooks
	sudo ln -s -f $DIR/pacman-mirrorlist-upgrade.hook /etc/pacman.d/hooks/pacman-mirrorlist-upgrade.hook
fi

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

ZSHRC_CONFIG=~/.zshrc
ln -s -f $DIR/zshrc $ZSHRC_CONFIG

# to support aliases inside of vim (:!gs for example)
ZSHENV_CONFIG=~/.zshenv
ln -s -f $DIR/zshenv $ZSHENV_CONFIG

# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"