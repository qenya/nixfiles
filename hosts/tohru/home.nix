{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
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

    dconf = {
      enable = true;
      settings =
        let
          backgroundOptions = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${config.users.users.qenya.home}/.background-image";
            primary-color = "#3a4ba0";
            secondary-color = "#2f302f";
          };
        in
        {
          "org/gnome/desktop/background" = backgroundOptions // {
            picture-uri-dark = backgroundOptions.picture-uri;
          };
          "org/gnome/desktop/screensaver" = backgroundOptions;
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
    };
    home.file.".background-image".source = ./background-image.jpg;

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
