#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$USER" == "root" ]; then
	mkdir -p ~/.files
	ln -s -f $DIR ~/.files
else
	ZLOGIN_CONFIG=~/.zlogin
	ln -s -f $DIR/zlogin $ZLOGIN_CONFIG
fi

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

ZSHRC_CONFIG=~/.zshrc
ln -s -f $DIR/zshrc $ZSHRC_CONFIG

# to support aliases inside of vim (:!gs for example)
ZSHENV_CONFIG=~/.zshenv
ln -s -f $DIR/zshenv $ZSHENV_CONFIG

ZSHPROFILE_CONFIG=~/.zprofile
ln -s -f $DIR/zprofile $ZSHPROFILE_CONFIG

# Install plugins 
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"; fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; fi
