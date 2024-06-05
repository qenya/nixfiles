{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/gnome
      ../../home/vscode.nix
    ];

    home.homeDirectory = config.users.users.qenya.home;

    home.packages = with pkgs; [
      fortune
      htop
      tree

      bitwarden
      tor-browser-bundle-bin
    ];

    programs.chromium.enable = true;
    programs.firefox.enable = true;

    programs.git = {
      enable = true;
      userName = "Katherina Walshe-Grey";
      userEmail = "git@katherina.rocks";
    };

    home.stateVersion = "23.11";
  };
}
