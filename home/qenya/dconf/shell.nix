{ config, lib, pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = true;

      # TODO: this is fine for now on tohru (the only GNOME system I use) but shouldn't depend on certain apps being installed
      favorite-apps = [
        "discord.desktop"
        "org.gnome.Evolution.desktop"
        "firefox.desktop"
        "torbrowser.desktop"
        "steam.desktop"
        "codium.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.SystemMonitor.desktop"
      ];

      # TODO: fill this out (needs preinstalled stuff removing first)
      # app-picker-layout = [
      #   ...
      # ];
    };
  };
}
