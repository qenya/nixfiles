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
    "org/gnome/desktop/sound".allow-volume-above-100-percent = true;
  };

  imports = [
    ./desktop.nix
    ./keyboard.nix
    ./mouse-touchpad.nix
    ./multitasking.nix
    ./shell.nix
  ];
}
