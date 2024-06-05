{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/btop.nix
      ../../home/cli.nix
      ../../home/gnome
      ../../home/vscode.nix
    ];

    home.packages = with pkgs; [
      bitwarden
      tor-browser-bundle-bin
    ];

    programs.chromium.enable = true;
    programs.firefox.enable = true;

    home.stateVersion = "23.11";
  };
}
