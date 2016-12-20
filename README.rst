==============================
 My Desktop Environment Setup
==============================

My configuration and customization bits for WM/DEs.

Currently includes stuff for `Enlightenment <http://enlightenment.org>`_ (E17+).

Feel free to reuse any of these stuff as you see fit.

.. contents::
  :backlinks: none



General Info
============

It's not some cool tiling setup, as I prefer (and use) fullscreen windows on
separate "virtual desktops" anyway. And where I don't (e.g. floating skype,
terminals), just bind a key to position things at some fixed location/size
and/or set these to be persistent for specific app windows.

I don't use DE menu(s?) - either have a key to start what I need (on a constant
virtual desktop), use `dmenu <http://tools.suckless.org/dmenu/>`_ to launch more
rare stuff or just run it from one of the terminals (`yeahconsole
<http://phrat.de/yeahtools.html>`_) on top, general xterm which I always have
open).

Don't have any *dm (as in GDM, KDM, etc), simply starting WM with screen locker
on boot instead, as there's never more than one physical user here anyway.

"systemd --user" + systemd-logind session setup without *dm is a bit unorthodox
in general, and in my case done through a custom `pam-run
<https://github.com/mk-fg/fgtk/#pam-run>`_ pam-session-wrapper binary,
with Xorg, WM and everything DE-related started in user@1000 daemon's
"startx.target" - see stuff under "systemd" for more info.



Specific components
===================

Notes on specific components of the setup, usually in their own subtrees.


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
