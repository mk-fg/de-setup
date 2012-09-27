#!/bin/sh

# Basic X setup
xrdb ~/.Xresources
export XDG_DATA_DIRS=$HOME/.xdg:/usr/share/enlightenment:/usr/share

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

# e17/systemd session
ck-launch-session enlightenment_start
pkill -INT -U $UID -x systemd ||: # make sure it's dead
