# Basic X setup
xrdb ~/.Xresources
xmodmap ~/.xmodmaprc
xset r rate 250 40
setxkbmap -rules evdev -layout 'us,ru' -option 'grp:switch,grp:caps_toggle,grp_led:caps'

xsetroot -solid black
aura -n || aura -d /mnt/volatiles/images ~/media/bgz

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

# Initial eye-candy
redshift -m randr -l 56.8:60.6 -t 6500:4000 &
yeahconsole &
conky &

# WM
fifo=/tmp/.wm.fifo
rm -f  "$fifo"
mkfifo "$fifo" || exit
logger -p user.info -t wm <"$fifo" &
ck-launch-session sawfish 2>&1 | tee "$fifo"
