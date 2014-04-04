#!/bin/sh

# For proper PATH and such
source /etc/profile

# Agents
create_zenv_file() {
	touch /dev/shm/zenv_agents
	chgrp wheel /dev/shm/zenv_agents
	chmod 660 /dev/shm/zenv_agents
}
if ! pgrep gpg-agent >/dev/null; then
	create_zenv_file 2>/dev/null
	gpg-agent >>/dev/shm/zenv_agents --daemon --pinentry-program $(which pinget)
fi
if ! pgrep ssh-agent >/dev/null; then
	create_zenv_file 2>/dev/null
	ssh-agent | grep -v '^echo' >>/dev/shm/zenv_agents
fi
source /dev/shm/zenv_agents

# Misc env
export ELM_THEME=elm-efenniht
export XDG_DATA_DIRS="${HOME}/.xdg:/usr/share/enlightenment:/usr/share"
export XDG_RUNTIME_DIR=/run/user/fraggod
mkdir -p "$(dirname "$(echo $DBUS_SESSION_BUS_ADDRESS | cut -d= -f2)")"

exec ck-launch-session /usr/lib/systemd/systemd --user --unit=startx.target
