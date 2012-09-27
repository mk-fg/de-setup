#!/bin/sh

# Basic X setup
xrdb ~/.Xresources

# Agents
if ! pgrep gpg-agent || ! pgrep ssh-agent; then
	pkill gpg-agent
	pkill ssh-agent
	truncate -s0 /dev/shm/zenv_agents 2>/dev/null
	chgrp wheel /dev/shm/zenv_agents 2>/dev/null
	chmod 660 /dev/shm/zenv_agents 2>/dev/null
	gpg-agent >>/dev/shm/zenv_agents --daemon --pinentry-program $(which pinget)
	ssh-agent | grep -v '^echo' >>/dev/shm/zenv_agents
fi
source /dev/shm/zenv_agents

# systemd/e17 session
export XDG_DATA_DIRS="${HOME}/.xdg:/usr/share/enlightenment:/usr/share"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/session_bus_socket"
ck-launch-session /usr/lib/systemd/systemd --user
