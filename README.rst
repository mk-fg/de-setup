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
virtual desktop), use `dmenu <http://tools.suckless.org/dmenu/>`_ to launch more
rare stuff or just run it from one of the terminals (`yeahconsole
<http://phrat.de/yeahtools.html>`_) on top, general xterm which I always have
open).



Specific components
===================

Notes on specific components of the setup, usually in their own subtrees.


Systemd system/user-session units
---------------------------------

Don't have any \*dm (as in GDM, KDM, etc), simply starting WM with screen locker
(``enlightenment -locked``) on boot instead, as there's never more than one
physical user here anyway.

``systemd --user`` + systemd-logind session setup without \*dm is a bit
unorthodox in general, and in my case started through a custom `pam-run
<https://github.com/mk-fg/fgtk/#pam-run>`_ pam-session-wrapper binary, with
Xorg, WM and everything DE-related started in user\@1000 daemon's
"startx.target" - see stuff under "systemd" for more info.


Enlightenment configs (e/e.cfg.*)
---------------------------------

Created/processed by `e_config_backup
<https://github.com/mk-fg/fgtk/#e-config-backup>`_ tool (`yapps2-based parser
<http://blog.fraggod.net/2013/01/21/pyparsing-vs-yapps.html>`_), and used to
detect any new options between version upgrades, or (super-rare) `migrations between config schemas
<http://blog.fraggod.net/2013/01/16/migrating-configuration-settings-to-e17-enlightenment-0170-from-older-e-versions.html>`_,
if necessary.


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

``rc.laptop`` is a cut-down version of ``rc.desktop`` for smaller screen.

Requres conky lua extension enabled (at build-time, not the case on Arch for
some reason) and uses tiny "sens" binary for lm_sensors readouts, started from
lua with separate interval, with outputs cached between runs.

Use "make" to build it.

See this `Displaying any lm_sensors data in conky
<http://blog.fraggod.net/2014/05/19/displaying-any-lm_sensors-data-temperature-fan-speeds-voltage-etc-in-conky.html>`_
post for more details/screenshots.


mpv
---

``script=...`` option can be used in the main config (e.g. ``~/.mpv/config``) to
load lua stuff, like this: ``script=~/.mpv/fg.status.lua`` (one line per script)

fg.lavfi-audio-vis.lua abuses --lavfi-complex to produce visualizations
(overlaid showcqt + avectorscope filters atm) for audio-only files if window
is enabled/available (e.g. via --force-window=immediate) and there's no video
stream in it (album art don't count).



xbindkeys
---------

Config used to debounce middle-button clicks on a Razer mouse that I have -
apparently common issue with this particular brand.

More info in `Debounce bogus repeated mouse clicks
<http://blog.fraggod.net/2016/05/15/debounce-bogus-repeated-mouse-clicks-in-xorg-with-xbindkeys.html>`_
blog post.
