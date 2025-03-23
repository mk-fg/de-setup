# My Desktop Environment Setup

My configuration and customization bits for WM/DEs.

Currently includes stuff for [Enlightenment] (E17+) on X11.

Feel free to reuse anything of value in this however you want.

[Enlightenment]: https://enlightenment.org

**Table of Contents**

- [General Info](#hdr-general_info)

- [Specific components](#hdr-specific_components)

    - [Systemd system/user-session units](#hdr-systemd_system_user-session_units)
    - [Enlightenment configs (e/e.cfg.*)](#hdr-enlightenment_configs__e_e.cfg.__)
    - [Enlightenment Edje Themes (e/themes)](#hdr-enlightenment_edje_themes__e_themes_)
    - [conky](#hdr-conky)
    - [mpv](#hdr-mpv)

        - [fg.status.lua](#hdr-fg.status.lua)
        - [fg.lavfi-audio-vis.lua](#hdr-fg.lavfi-audio-vis.lua)
        - [fg.file-keys.lua](#hdr-fg.file-keys.lua)

    - [xbindkeys](#hdr-xbindkeys)
    - [bin](#hdr-bin)
    - [Themes](#hdr-themes)

Repository URLs:

- https://github.com/mk-fg/de-setup
- https://codeberg.org/mk-fg/de-setup
- https://fraggod.net/code/git/de-setup



<a name=hdr-general_info></a><a name=user-content-hdr-general_info></a>
## General Info

It's not some cool tiling setup, as I prefer (and use) fullscreen windows on
separate "virtual desktops" anyway. And where I don't (e.g. floating messenger,
terminals, mpv), just bind a key to position things at some fixed location/size
and/or set these to be persistent for specific app windows.

Don't use DE menu(s?) - either have a key to start what I need (on a constant
virtual desktop), use [dmenu] to launch more rare stuff or just run it from one
of the terminals - [yeahconsole] on top or generic terminal window that's always
open on desktop-1.

[dmenu]: https://tools.suckless.org/dmenu/
[yeahconsole]: http://phrat.de/yeahtools.html


<a name=hdr-specific_components></a><a name=user-content-hdr-specific_components></a>
## Specific components

Notes on specific components of the setup, usually in their own subtrees.



<a name=hdr-systemd_system_user-session_units></a><a name=user-content-hdr-systemd_system_user-session_units></a>
### Systemd system/user-session units

Don't have any \*dm (as in GDM, KDM, etc), simply starting WM with screen locker
(`enlightenment -locked`) on boot instead, as there's never more than one
physical user here anyway.

`systemd --user` + systemd-logind session setup without \*dm is a bit
unorthodox in general, and in my case started through a custom [pam-run]
pam-session-wrapper binary, with Xorg, WM and everything DE-related started in
user\@1000 daemon's "startx.target" - see stuff under "systemd" for more info.

[pam-run]: https://github.com/mk-fg/fgtk/#hdr-pam-run



<a name=hdr-enlightenment_configs__e_e.cfg.__></a><a name=user-content-hdr-enlightenment_configs__e_e.cfg.__></a>
### Enlightenment configs (e/e.cfg.*)

Created/processed by [e-config-backup] tool (eet/TextX-based parser),
and used to detect any new options between version upgrades, or (rare)
[migrations between config schemas].

[e-config-backup]: bin/e-config-backup
[migrations between config schemas]:
  https://blog.fraggod.net/2013/01/16/migrating-configuration-settings-to-e17-enlightenment-0170-from-older-e-versions.html



<a name=hdr-enlightenment_edje_themes__e_themes_></a><a name=user-content-hdr-enlightenment_edje_themes__e_themes_></a>
### Enlightenment Edje Themes (e/themes)

Mostly based on ones from E repositories, and might include assets
(icons, sounds, etc) from these, so not original by any means, just tweaked slightly.

Terminology color theme ini files can be installing using `./data/colorschemes/add_color_scheme.sh`
script from terminology repo, as described in COLORSCHEMES.md, for example:

    % ./data/colorschemes/add_color_scheme.sh \
      eet ~/.config/terminology/colorschemes.eet dark-fir.ini



<a name=hdr-conky></a><a name=user-content-hdr-conky></a>
### conky

Common "top + stuff" vertical layout with radial displays
and (mostly decorative) analog/binary clocks on top.

`rc.laptop` is a cut-down version of `rc.desktop` for smaller screen.

Requres conky lua extension enabled (at build-time, not the case on Arch
for some reason), with cairo support for fancy visual clocks, and uses JSON
output of "sensors" binary from [lm_sensors].

![conky-sensors](https://blog.fraggod.net/images/conky_sensors.jpg)

Current bottom part of the window is a cached events/calendar reminder,
included via `${catp /run/user/1000/cal.conky}` conky-config output
from ["riet" tool], which is updating it on its own separate schedule
(`riet cal.rst -c /run/user/1000/conky.calendar` in crontab).

"sensors" binary there is being run from lua with separate interval
(configured in lua sensors= map), and its outputs cached between runs,
so doesn't update on the same interval as while conky UI, to avoid
running it every few seconds needlessly.

Lua script formats sensor values as `chip__feature__subfeature` (e.g.
`k10temp-pci-00c3__Tctl__temp1_input` for `"k10temp-pci-00c3":{"Tctl":{"temp1_input":48.000}`
nested-JSON data), which conky's `${lua sens_read ...}` can match by any string part
or [lua regexp-like string.match pattern] - for example
`${lua sens_read k10temp-pci-[^_]+__Tctl__temp%d+_input}` to match any available
temperature value on k10temp-pci "Tctl" feature (AMD CPU temperature), regardless
of bus IDs and sensor number (as there's probably just one for Tctl).\
Run `lua conky/helpers.lua` from the terminal (command line) to check/test
lua-parsed sensors' names and outputs directly, same as in conky config.

[Displaying any lm_sensors data in conky] blog post has a bit more details,
but outdated by now - used to need separate "sens" binary, obsoleted by
lm\_sensors' `-j` option.

[lm_sensors]: https://archive.kernel.org/oldwiki/hwmon.wiki.kernel.org/lm_sensors.html
["riet" tool]: https://github.com/mk-fg/rst-icalendar-event-tracker
[lua regexp-like string.match pattern]: https://www.lua.org/manual/5.4/manual.html#6.4.1
[Displaying any lm_sensors data in conky]:
  https://blog.fraggod.net/2014/05/19/displaying-any-lm_sensors-data-temperature-fan-speeds-voltage-etc-in-conky.html



<a name=hdr-mpv></a><a name=user-content-hdr-mpv></a>
### mpv

`script=...` option can be used in the main config (e.g. `~/.mpv/config`) to
load lua stuff, like this: `script=~/.mpv/fg.status.lua` (one line per script)


<a name=hdr-fg.status.lua></a><a name=user-content-hdr-fg.status.lua></a>
#### [fg.status.lua]
[fg.status.lua]: mpv/fg.status.lua

Default mpv status line replacement, with all the stuff that default one
provides (with a bit nicer format), plus audio/video bitrate and some extra
caching info.

Usually can look something like this:\
`VAS: 00:10:16 / 00:23:40 (43%) -- cached  >95% 10s+64M/64M [B/s V:366K A:15K]`

Where "VAS" are available streams (video/audio/subtitles), then time/position and
buffering% / idle / paused state prefix, cache status (cached/caching, %full,
decoded seconds, used/max state in dynamic B/K/M/G units), and then A/V bitrates
(same auto-scaled units).

Bitrates are generally useful when streaming stuff over network.


<a name=hdr-fg.lavfi-audio-vis.lua></a><a name=user-content-hdr-fg.lavfi-audio-vis.lua></a>
#### [fg.lavfi-audio-vis.lua]
[fg.lavfi-audio-vis.lua]: mpv/fg.lavfi-audio-vis.lua

Parameter-tweaker script that abuses --lavfi-complex to produce visualizations
(overlaid showcqt + avectorscope filters atm) for audio-only files if window is
enabled/available (e.g. via --force-window=immediate) and there's no video
stream in it (album art don't count).

![mpv-ffmpeg-vis](https://blog.fraggod.net/images/mpv-ffmpeg-vis.jpg)

I.e. some fancy dynamic swarming/flowing colors instead of just blank black square.

Also includes client events to toggle visualization and other --lavfi-complex
filtering (if any) on/off explicitly, regardless of whether it was enabled on
start.

Can be used for key bindings, e.g. via something like `y script-message
fg.lavfi-audio-vis.on` in input.conf, and I'm using that in a player frontend
([emms](https://github.com/mk-fg/emacs-setup/blob/master/core/fg_emms.el)).


<a name=hdr-fg.file-keys.lua></a><a name=user-content-hdr-fg.file-keys.lua></a>
#### [fg.file-keys.lua]
[fg.file-keys.lua]: mpv/fg.file-keys.lua

Simple script to remove or manage playback timestamp in currently-playing
filename, useful to cleanup or mark/seek whatever transient media files,
as you go through them, e.g. one-off downloaded stuff from [yt-dlp].

[yt-dlp]: https://github.com/yt-dlp/yt-dlp


<a name=hdr-xbindkeys></a><a name=user-content-hdr-xbindkeys></a>
### [xbindkeys]
[xbindkeys]: xbindkeys.scm

Config used to debounce middle-button clicks on a Razer mouse that I have -
apparently common issue with this particular brand.
More info in [Debounce bogus repeated mouse clicks] blog post.

[Debounce bogus repeated mouse clicks]:
  https://blog.fraggod.net/2016/05/15/debounce-bogus-repeated-mouse-clicks-in-xorg-with-xbindkeys.html



<a name=hdr-bin></a><a name=user-content-hdr-bin></a>
### bin

Somewhat-obsolete scripts for whatever startup/init functionality and key bindings.

See [fgtk repo](https://github.com/mk-fg/fgtk) for much more of these,
incl. a ton of generic DE-independent desktop-related stuff.

Somewhat notable stuff:

- [fgrun](bin/fgrun) -
  python3 wrapper for dmenu, preserving and deduplicating history,
  as well as scraping/caching list of binaries for selection there.

- [fgbg](bin/fgbg) -
  py3/ctypes/sd-bus script to set background in whatever current DE.

  Has continuous operation mode to run as desktop session daemon and cycle
  images, as well as some options to scale/position/process them for
  DE-background purposes using [ImageMagick] (via [wand-py] module).

  Image processing is actually quite complicated (mostly copied from earlier
  [aura] background-setter project atm), and has plenty of scale/opacity/offset/blur
  and such options in ImageMagickOpts and ImageMagickTallScale dataclasses.

- [xclipc](bin/xclipc) - obsoleted but useful key-bound script, for adding
  some processing to some "copy to clipboard" operations, as well as making
  these more universal wrt diff X selection buffers.

  [exclip] is a more modern, fast and robust replacement for that hack.

- xinitrc.\* - tweaks for various X input/display parameters like keyboard rates
  and layouts, dpms, mouse/touchpad stuff, xmodmap, etc.

  Useful to keep these outside of xorg.conf to be able to change re-apply them
  at any time without having to restart anything or remember all the commands again.

- [e-config-backup]

  Python3 + eet (EFL lib/tool) + [TextX]-based parser script for Enlightenment
  (E17+) config file(s), to backup these under e/ dir here.

  Whole purpose of decoding/encoding dance is to sort the sections
  (which E orders arbitrarily) and detect/filter-out irrelevant changes
  like remembered window positions or current (transient) wallpaper path.

[ImageMagick]: https://www.imagemagick.org/
[wand-py]: https://docs.wand-py.org/
[aura]: https://github.com/mk-fg/aura
[exclip]: https://blog.fraggod.net/2018/04/10/linux-x-desktop-clipboard-keys-via-exclip-tool.html
[TextX]: https://textx.github.io/textX/



<a name=hdr-themes></a><a name=user-content-hdr-themes></a>
### Themes

Don't really need much from these, as browser, mpv, emacs and terminal have
their own styles, and I spend almost all in just these few apps.

Used in [claws-mail] and dialog windows (e.g. rare "Select File" in browser)
and context menus.

- Theme - default GTK dark-mode one, ``~/.gtkrc-3.0``:

    ``` ini
    [Settings]
    gtk-application-prefer-dark-theme = true
    ```

- [claws-mail] icons - [PapirusDevelopmentTeam/papirus-claws-mail-theme] (dark-bg version)

[claws-mail]: https://www.claws-mail.org/
[PapirusDevelopmentTeam/papirus-claws-mail-theme]:
  https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme
