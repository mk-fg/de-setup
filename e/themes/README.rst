===========================
 Enlightenment Edje Themes
===========================

Mostly based on ones from E repositories, and might include assets (icons,
sounds, etc) from these, so not created here by any means, just tweaked slightly.

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
