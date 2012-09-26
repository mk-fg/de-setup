#!/bin/sh

# Logging
mv ~/.e/lastrun.log{,.old} 2>/dev/null ||:
exec 1>~/.e/lastrun.log 2>&1

# Basic X setup
xrdb ~/.Xresources
export XDG_DATA_DIRS=$HOME/.xdg:$XDG_DATA_DIRS

# DBus session bus
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] &&\
	eval $(dbus-launch --sh-syntax --exit-with-session)

# Agents
pkill gpg-agent
pkill ssh-agent
truncate -s0 /dev/shm/zenv_agents 2>/dev/null
chgrp wheel /dev/shm/zenv_agents 2>/dev/null
chmod 660 /dev/shm/zenv_agents 2>/dev/null
gpg-agent >>/dev/shm/zenv_agents --daemon --pinentry-program $(which pinget)
ssh-agent | grep -v '^echo' >>/dev/shm/zenv_agents
source /dev/shm/zenv_agents

# WM
exec systemd-inhibit ck-launch-session enlightenment_start
