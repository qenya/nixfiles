{ config, lib, pkgs, ... }:

{
  dconf.enable = true;

  programs = {
    firefox.enable = true; # TODO: config is not yet nix-ified
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    bitwarden
    discord
    foliate
    gimp-with-plugins
    jellyfin-media-player
    keepassxc
    tor-browser-bundle-bin
    zoom-us

    # libreoffice
    libreoffice
    hunspell
    hunspellDicts.en_GB-ise

    # games
    openttd
    prismlauncher
    nur.repos.qenya.digital-a-love-story
    nur.repos.qenya.dont-take-it-personally-babe
  ];
}
