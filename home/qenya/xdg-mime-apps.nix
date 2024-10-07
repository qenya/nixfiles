{ config, lib, pkgs, osConfig, ... }:

let
  isGraphical = osConfig.services.xserver.enable;
in
{
  xdg.mimeApps = {
    enable = isGraphical;
    defaultApplications = {
      "application/zip" = [ "org.gnome.FileRoller.desktop" "org.kde.ark.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" "org.kde.gwenview.desktop" ];
      "text/plain" = [ "org.gnome.TextEditor.desktop" "org.kde.kate.desktop" ];
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/mailto" = "org.gnome.Evolution.desktop"; # TODO: email on KDE - is Kontact any good?
    };
  };
}
