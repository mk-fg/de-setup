# Basic X setup
xrdb ~/.Xresources
xsetroot -solid black
xinitrc.input
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

# User daemons
aura -n || aura -d /mnt/volatiles/images ~/media/bgz

logtail_notify_lock="$XDG_RUNTIME_DIR"/logtail_notify.lock
touch "$logtail_notify_lock"
flock -n 0 <"$logtail_notify_lock" || pkill -g $(cat "$logtail_notify_lock")
setsid flock "$logtail_notify_lock"\
	-c 'logtail_notify\
		-i ~/media/appz/icons/biohazard_48x.png\
		-x "$XDG_RUNTIME_DIR"/logtail_notify.db\
		/var/log/syslog/stripped.log' &
echo $! >"$logtail_notify_lock"

# Initial eye-candy
redshift -m randr -l 56.8:60.6 -t 6500:4000 &
yeahconsole &
conky &

# WM
fifo=/tmp/.wm.fifo
rm -f  "$fifo"
mkfifo "$fifo" || exit
logger -p user.info -t wm <"$fifo" &

exec ck-launch-session sawfish 2>&1 | tee "$fifo"
