My Desktop Environment Setup
--------------------

My configuration and customization bits for WM/DEs.
Currently includes stuff for [Enlightenment](http://enlightenment.org) (E17+).

It's not some cool tiling setup, as I prefer (and use) fullscreen windows on
separate "virtual desktops" anyway. And where I don't (e.g. floating skype,
terminals), just bind a key to position the thing at some fixed location/size.

I don't use DE menu(s?) - either have a key to start what I need (on a constant
virtual desktop), use [dmenu](http://tools.suckless.org/dmenu/) to launch more
rare stuff or just run it from one of the terminals
([yeahconsole](http://phrat.de/yeahtools.html) on top, general xterm which I
always have open).

Don't have any *dm (as in GDM, KDM, etc), simply starting WM with screen locker
instead, as there's never more than one physical user here anyway.

systemd-logind setup without *dm is a bit unorthodox in general, and in my case
done through custom [pam-run](https://github.com/mk-fg/fgtk/#pam-run)
session-wrapper binary, with Xorg, WM and everything DE-related started in
user@1000 "systemd --user" daemon's "startx.target".
