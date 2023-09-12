#!/bin/bash

env_file=/tmp/.zenv.agents
env_ext="${BASH_SOURCE[0]}".env

env_pids=()
exit_cleanup() {
	systemctl --user --no-block exit &
	disown # to avoid lockups in case of systemd/dbus fails
	for pid in "${env_pids[@]}"; do kill "$pid"; done
}
trap exit_cleanup TERM INT

init_zenv_file() {
	:> "$env_file"
	chgrp wheel "$env_file"
	chmod 660 "$env_file"
}

# For proper PATH and such
source /etc/profile

# Misc env
export LANG=en_US.utf8
export LC_ALL=$LANG
export DISPLAY=:1
export NO_AT_BRIDGE=1
export GTK_MODULES="libcanberra-gtk-module.so"
export XDG_DATA_DIRS="${HOME}/.xdg:/usr/share/enlightenment:/usr/share"
[[ -r "$env_ext" ]] && source "$env_ext"

# Agents
init_zenv_file 2>/dev/null
systemd-run --user --unit=fg-ssh-agent -p Type=forking -- bash -c "ssh-agent | grep -v '^echo ' >>'$env_file'"
source "$env_file"

# Systemd env import and X start
systemctl --user import-environment
systemctl --user start startx.target

sleep infinity &
env_pids+=( $! )
wait

exit 0
