{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/cli.nix
      ../../home/firefox.nix
      ../../home/gnome
      ../../home/vscode.nix
    ];

    home.packages = with pkgs; [
      bitwarden
      tor-browser-bundle-bin
    ];
    programs.chromium.enable = true;

    home.stateVersion = "23.11";
  };
}
