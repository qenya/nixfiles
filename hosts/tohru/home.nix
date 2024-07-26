{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/cli.nix
      ../../home/firefox.nix
      ../../home/git.nix
      ../../home/gnome
      ../../home/vscode.nix
      ../../home/zsh.nix
    ];

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

    home.stateVersion = "23.11";
  };
}
