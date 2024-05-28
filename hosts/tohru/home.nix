{ config, lib, pkgs, ... }:

{
  users.users.bluebird = {
    isNormalUser = true;
    description = "Bluebird";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      # TODO: move these to home-manager
      bitwarden
      firefox
      tor-browser-bundle-bin
    ];
  };

  home-manager.users.bluebird = { pkgs, ... }: {
    home.packages = [
      pkgs.fortune
      pkgs.htop
      pkgs.tree
    ];    

    programs.git = {
      enable = true;
      userName = "Katherina Walshe-Grey";
      userEmail = "git@katherina.rocks";
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
      ];
    };

    home.stateVersion = "23.11";
  };
}
