{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) optionals;
  isGraphical = osConfig.services.xserver.enable;
in
{
  home.packages = with pkgs; [
    eza # like `ls` but fancier
    hexyl # like `xxd` but cooler
    tree # like `ls -R` but nicer
    units
    zip unzip

    # Extremely important
    fortune
    cowsay
    lolcat
  ] ++ optionals isGraphical [
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
