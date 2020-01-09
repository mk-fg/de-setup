==============================
 My Desktop Environment Setup
==============================

My configuration and customization bits for WM/DEs.

Currently includes stuff for `Enlightenment <http://enlightenment.org>`_ (E17+).

Feel free to reuse any of this stuff as you see fit.

.. contents::
  :backlinks: none



General Info
============

It's not some cool tiling setup, as I prefer (and use) fullscreen windows on
separate "virtual desktops" anyway. And where I don't (e.g. floating skype,
terminals), just bind a key to position things at some fixed location/size
and/or set these to be persistent for specific app windows.

Don't use DE menu(s?) - either have a key to start what I need (on a constant
virtual desktop), use dmenu_ to launch more rare stuff or just run it from one
of the terminals - yeahconsole_ on top or generic terminal window that's always
open on desktop-1.

.. _dmenu: http://tools.suckless.org/dmenu/
.. _yeahconsole: http://phrat.de/yeahtools.html


Specific components
===================

Notes on specific components of the setup, usually in their own subtrees.


Systemd system/user-session units
---------------------------------

Don't have any \*dm (as in GDM, KDM, etc), simply starting WM with screen locker
(``enlightenment -locked``) on boot instead, as there's never more than one
physical user here anyway.

``systemd --user`` + systemd-logind session setup without \*dm is a bit
unorthodox in general, and in my case started through a custom pam-run_
pam-session-wrapper binary, with Xorg, WM and everything DE-related started in
user\@1000 daemon's "startx.target" - see stuff under "systemd" for more info.

.. _pam-run: https://github.com/mk-fg/fgtk/#pam-run


Enlightenment configs (e/e.cfg.*)
---------------------------------

Created/processed by `e_config_backup`_ tool (`yapps2-based parser`_), and used
to detect any new options between version upgrades, or (super-rare) `migrations
between config schemas`_, if necessary.

.. _e_config_backup: https://github.com/mk-fg/fgtk/#e-config-backup
.. _yapps2-based parser: http://blog.fraggod.net/2013/01/21/pyparsing-vs-yapps.html
.. _migrations between config schemas: http://blog.fraggod.net/2013/01/16/migrating-configuration-settings-to-e17-enlightenment-0170-from-older-e-versions.html


Enlightenment Edje Themes (e/themes)
------------------------------------

Mostly based on ones from E repositories, and might include assets (icons,
sounds, etc) from these, so not original by any means, just tweaked slightly.

Included Makefiles can be used to build ``*.edc`` themes (using edje_cc),
i.e. just run "make" to produce ``*.edj`` files from these.

edj files go to paths like ``~/.e/e/themes/`` or ``~/.config/terminology/themes/``,
depending on the app.

``*.eet.cfg`` files are extracted using something like::

  % eet -l ~/.config/terminology/config/standard/base.cfg
  config

  % eet -d ~/.config/terminology/config/standard/base.cfg config terminology.eet.cfg

To encode these back to eet blobs::

  % eet -e ~/.config/terminology/config/standard/base.cfg config terminology.eet.cfg 0

Terminology needs specific config in addition to edje theme to have contrast
ISO-6429 colors on top of theme-specific background/features.

``_xterm-colors-to-eet.py`` script can be used to generate ISO-6429 color values
for terminology eet config file, e.g. from `xresources <xresources>`_ file with
xterm colors and sync colors between the two without having to enter these
manually.


conky
-----

Common "top + stuff" vertical layout with radial displays
and (mostly decorative) analog/binary clocks on top.

``rc.laptop`` is a cut-down version of ``rc.desktop`` for smaller screen.

Requres conky lua extension enabled (at build-time, not the case on Arch for
some reason) and uses tiny "sens" binary for lm_sensors readouts, started from
lua with separate interval, with outputs cached between runs.

Use "make" to build it.

.. raw:: html

  <img src="http://blog.fraggod.net/images/conky_sensors.jpg" height="600px">

`Displaying any lm_sensors data in conky`_ blog post has more details on how it all works.

.. _Displaying any lm_sensors data in conky: http://blog.fraggod.net/2014/05/19/displaying-any-lm_sensors-data-temperature-fan-speeds-voltage-etc-in-conky.html


mpv
---

``script=...`` option can be used in the main config (e.g. ``~/.mpv/config``) to
load lua stuff, like this: ``script=~/.mpv/fg.status.lua`` (one line per script)

fg.status.lua
`````````````

Default mpv status line replacement, with all the stuff that default one
provides (with a bit nicer format), plus audio/video bitrate and some extra
caching info.

| Usually can look something like this:
| ``VAS: 00:10:16 / 00:23:40 (43%) -- cached  >95% 10s+64M/64M [B/s V:366K A:15K]``
|

Where "VAS" are available streams (video/audio/subtitles), then time/position and
buffering% / idle / paused state prefix, cache status (cached/caching, %full,
decoded seconds, used/max state in dynamic B/K/M/G units), and then A/V bitrates
(same auto-scaled units).

Bitrates are generally useful when streaming stuff over network.

fg.lavfi-audio-vis.lua
``````````````````````

Parameter-tweaker script that abuses --lavfi-complex to produce visualizations
(overlaid showcqt + avectorscope filters atm) for audio-only files if window is
enabled/available (e.g. via --force-window=immediate) and there's no video
stream in it (album art don't count).

.. raw:: html

  <img src="http://blog.fraggod.net/images/mpv-ffmpeg-vis.jpg" height="400px">

I.e. some fancy dynamic swarming/flowing colors instead of just blank black square.

Also includes client events to toggle visualization and other --lavfi-complex
filtering (if any) on/off explicitly, regardless of whether it was enabled on start.

Can be used for key bindings, e.g. via something like ``y script-message
fg.lavfi-audio-vis.on`` in input.conf, and I'm using that in a player frontend
(`emms <https://github.com/mk-fg/emacs-setup/blob/master/core/fg_emms.el>`_).


xbindkeys
---------

Config used to debounce middle-button clicks on a Razer mouse that I have -
apparently common issue with this particular brand.

More info in `Debounce bogus repeated mouse clicks`_ blog post.

.. _Debounce bogus repeated mouse clicks: http://blog.fraggod.net/2016/05/15/debounce-bogus-repeated-mouse-clicks-in-xorg-with-xbindkeys.html


bin
---

Somewhat-obsolete scripts for whatever startup/init functionality and key bindings.

See `fgtk repo <https://github.com/mk-fg/fgtk>`_ for much more of these,
incl. a ton of generic DE-independent desktop-related stuff.

Somewhat notable stuff:

- `fgrun <bin/fgrun>`_ -
  python3 wrapper for dmenu, preserving and deduplicating history,
  as well as scraping/caching list of binaries for selection there.

- `fgbg <bin/fgbg>`_ -
  py3/ctypes/sd-bus script to set background in whatever current DE.

- `xclipc <bin/xclipc>`_ - obsoleted but useful key-bound script, for adding
  some processing to some "copy to clipboard" operations, as well as making
  these more universal wrt diff X selection buffers.

  exclip_ is a more modern, fast and robust replacement for that hack.

- xinitrc.\* - tweaks for various X input/display parameters like keyboard rates
  and layouts, dpms, mouse/touchpad stuff, xmodmap, etc.

  Useful to keep these outside of xorg.conf to be able to change re-apply them
  at any time without having to restart anything or remember all the commands again.

.. _exclip: http://blog.fraggod.net/2018/04/10/linux-x-desktop-clipboard-keys-via-exclip-tool.html


Themes
------

Don't really need much from these, as browser, mpv, emacs and terminal have
their own styles, and I spend almost all in just these few apps.

Used in claws-mail_ and dialog windows (e.g. rare "Select File" in browser) and
context menus.

- Theme - `gnome-look.org/Breeze-Inspiration-Dark`_ (`L4ki/Inspiration`_)

  Has some diffs between gtk2/gtk3 versions, with gtk2 one (still used in
  claws-mail) having proper distinct borders but bogus highlighted-text color.

  Tweaks:

  - gtk.css: #131521 -> #1e3c61
  - gtkrc: "selected_fg_color:#bbe6f2"

- Common icons - `L4ki/Breeze-Inspiration-Icons`_ (same gnome-look.org set)

- claws-mail_ icons - `PapirusDevelopmentTeam/papirus-claws-mail-theme`_ (dark-bg version)

.. _claws-mail: https://www.claws-mail.org/
.. _gnome-look.org/Breeze-Inspiration-Dark: https://www.gnome-look.org/p/1342928/
.. _L4ki/Inspiration: https://github.com/L4ki/Inspiration-GTK-3-Theme
.. _L4ki/Breeze-Inspiration-Icons: https://github.com/L4ki/Breeze-Inspiration-Icons
.. _PapirusDevelopmentTeam/papirus-claws-mail-theme: https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme
