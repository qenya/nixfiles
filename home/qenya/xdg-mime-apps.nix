{ config, lib, pkgs, osConfig, ... }:

let
  isGraphical = osConfig.services.xserver.enable;
in
{
  xdg.mimeApps = {
    enable = isGraphical;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "image/gif" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
    };
  };
}