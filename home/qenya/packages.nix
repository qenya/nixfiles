{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) optionals;
  isGraphical = osConfig.services.xserver.enable;
  isGnome = osConfig.services.desktopManager.gnome.enable;
  isPlasma = osConfig.services.desktopManager.plasma6.enable;
in
{
  home.packages = with pkgs; [
    eza # like `ls` but fancier
    hexyl # like `xxd` but cooler
    ripgrep # like `grep` but faster
    tree # like `ls -R` but nicer
    units
    zip
    unzip

    # Extremely important
    fortune
    cowsay
    lolcat
  ] ++ optionals isGraphical [
    _1password-gui
    discord
    # https://github.com/NixOS/nixpkgs/issues/427155
    # gimp-with-plugins
    tor-browser
    zoom-us

    # libreoffice
    libreoffice
    hunspell
    hunspellDicts.en_GB-ise
  ] ++ optionals isGnome [
    celluloid
  ] ++ optionals isPlasma [
    haruna
  ];
}
