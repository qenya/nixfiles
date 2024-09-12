{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "fingers";
      disable-while-typing = false;
      natural-scroll = true; # the correct option, whatever Janet says
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
  };
}
