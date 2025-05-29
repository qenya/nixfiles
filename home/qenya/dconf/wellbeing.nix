{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/screen-time-limits".daily-limit-enabled = true;
    "org/gnome/desktop/break-reminders".selected-breaks = [ "eyesight" "movement" ];
  };
}
