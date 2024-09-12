{ config, lib, pkgs, osConfig, ... }:

# dconf is the configuration manager for GNOME.

let
  isGnome = osConfig.services.xserver.desktopManager.gnome.enable;
in
{
  dconf.enable = isGnome;

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/color".night-light-enabled = true;
    "org/gnome/desktop/sound".event-sounds = false;
  };

  imports = [
    ./desktop.nix
    ./keyboard.nix
    ./mouse-touchpad.nix
    ./multitasking.nix
    ./shell.nix
  ];
}
