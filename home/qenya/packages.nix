{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) optionals;
in
{
  home.packages = with pkgs; [
    tree # like `ls -R` but nicer
    units

    # Extremely important
    fortune
    cowsay
    lolcat
  ] ++ optionals osConfig.qenya.base-graphical.enable [
    bitwarden
    discord
    feishin
    gimp-with-plugins
    jellyfin-media-player
    tor-browser-bundle-bin
    zoom-us

    # libreoffice
    libreoffice
    hunspell
    hunspellDicts.en_GB-ise
  ];
}
