{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    dconf.enable = true;

    programs = {
      firefox.enable = true; # TODO: config is not yet nix-ified
      vscode.enable = true;
    };

    home.packages = (with pkgs; [
      bitwarden
      discord
      foliate
      gimp-with-plugins
      jellyfin-media-player
      keepassxc
      thunderbird
      tor-browser-bundle-bin

      # libreoffice
      libreoffice
      hunspell
      hunspellDicts.en_GB-ise

      # games
      openttd
      nur.repos.qenya.digital-a-love-story
      nur.repos.qenya.dont-take-it-personally-babe
    ]);
  };
}
