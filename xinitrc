#!/bin/bash

env_file=/tmp/.zenv.agents
env_ext="${BASH_SOURCE[0]}".env

# For proper PATH and such
source /etc/profile

# Agents
create_zenv_file() {
	touch "$env_file"
	chgrp wheel "$env_file"
	chmod 660 "$env_file"
}
if ! pgrep ssh-agent >/dev/null; then
	create_zenv_file 2>/dev/null
	ssh-agent | grep -v '^echo' >>"$env_file"
fi
pgrep gpg-agent >/dev/null || gpg-agent --daemon
source "$env_file"

# Misc env
export DISPLAY=:1
export ELM_THEME=elm-efenniht
export GTK_MODULES="libcanberra-gtk-module.so"
export XDG_DATA_DIRS="${HOME}/.xdg:/usr/share/enlightenment:/usr/share"
[[ -r "$env_ext" ]] && source "$env_ext"

systemctl --user import-environment
systemctl --user start startx.target
exec sleep infinity
