alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -h'
alias ll='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -hl'
alias la='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -hlA'
alias lt='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F -hlt'

alias grep='grep --color=tty -d skip'

alias df='df -h'

alias v='vim'
alias vn='vim -u NONE'

alias xcp='xclip-copyfile'
alias xcu='xclip-cutfile'
alias xpa='xclip-pastefile'

alias sudowayland="sudo --preserve-env=XDG_RUNTIME_DIR,WAYLAND_DISPLAY"

# One shouldn't add itself to docker group as mentioned here: https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user
alias docker='sudo docker'
alias docker-compose='sudo docker-compose'

up() {
	UPDATE_MIRRORS="n"
	CLEAN_CACHES="n"
	UPDATE_PACKAGES="y"

	while [ "$#" -gt 0 ]; do
		case "$1" in
			--update-mirrors) UPDATE_MIRRORS="y"; shift 1;;
			--only-update-mirrors) UPDATE_MIRRORS="y"; UPDATE_PACKAGES="n"; shift 1;;
			--clean-caches) CLEAN_CACHES="y"; shift 1;;
			--only-clean-caches) CLEAN_CACHES="y"; UPDATE_PACKAGES="n"; shift 1;;
		esac
	done

	if [ $UPDATE_MIRRORS = "y" ]; then
		echo "sudo systemctl start reflector"
		sudo systemctl start reflector
	fi

	if [ $CLEAN_CACHES = "y" ]; then
		echo "yay -Scc"
		yay -Scc
	fi

	if [ $UPDATE_PACKAGES != "n" ]; then
		echo "yay --news"
		yay --news

		echo "yay -Syu"
		yay -Syu

		echo "yay -P --stats"
		yay -P --stats
	fi
}

man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;40;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}
