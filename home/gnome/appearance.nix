{ config, lib, pkgs, ... }:

{
  dconf = {
    enable = true;
    settings =
      let
        backgroundOptions = {
          color-shading-type = "solid";
          picture-options = "zoom";
          picture-uri = "${config.home.homeDirectory}/.background-image";
          primary-color = "#3a4ba0";
          secondary-color = "#2f302f";
        };
      in
      {
        "org/gnome/desktop/background" = backgroundOptions // {
          picture-uri-dark = backgroundOptions.picture-uri;
        };
        "org/gnome/desktop/screensaver" = backgroundOptions;
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };
  };
  home.file.".background-image".source = ./background-image.jpg;
}
