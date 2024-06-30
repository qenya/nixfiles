{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/cli.nix
      ../../home/firefox.nix
      ../../home/git.nix
      ../../home/gnome
      ../../home/libreoffice.nix
      ../../home/vscode.nix
    ];

    home.packages = (with pkgs; [
      bitwarden
      discord
      foliate
      gimp-with-plugins
      keepassxc
      openttd
      thunderbird
      tor-browser-bundle-bin
    ]) ++ (with pkgs.nur.repos.qenya; [
      digital-a-love-story
      dont-take-it-personally-babe
    ]);
    programs.chromium.enable = true;

    home.stateVersion = "23.11";
  };
}
