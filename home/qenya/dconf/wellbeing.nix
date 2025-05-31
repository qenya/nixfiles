{ config, lib, pkgs, ... }:

# These features are cool and I would like to keep trying them, but they are
# horribly bugged in GNOME 48.1. Consider re-enabling them when 48.2 is
# released. See, e.g.:
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8289
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8299
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8305
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8376
# https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/8398

{
  dconf.settings = {
    # "org/gnome/desktop/screen-time-limits".daily-limit-enabled = true;
    # "org/gnome/desktop/break-reminders".selected-breaks = [ "eyesight" "movement" ];
    "org/gnome/desktop/screen-time-limits".daily-limit-enabled = false;
    "org/gnome/desktop/break-reminders".selected-breaks = [ ];
  };
}
