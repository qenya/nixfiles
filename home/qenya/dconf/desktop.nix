{ config, lib, pkgs, ... }:

let inherit (lib) mkIf;
in {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "${config.home.homeDirectory}/.background-image";
      picture-uri-dark = "${config.home.homeDirectory}/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
      picture-options = "zoom";
      picture-uri = "${config.home.homeDirectory}/.background-image";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
  };
  home.file.".background-image" = mkIf config.dconf.enable {
    source = ./background-image.jpg;
  };
}
