{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/gnome
      ../../home/vscode.nix
    ];

    home.packages = with pkgs; [
      fortune
      htop
      tree

      bitwarden
      tor-browser-bundle-bin
    ];

    programs.chromium.enable = true;
    programs.firefox.enable = true;

    home.stateVersion = "23.11";
  };
}
