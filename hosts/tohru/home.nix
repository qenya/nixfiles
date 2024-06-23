{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/cli.nix
      ../../home/firefox.nix
      ../../home/gnome
      ../../home/libreoffice.nix
      ../../home/vscode.nix
    ];

    home.packages = with pkgs; [
      bitwarden
      foliate
      keepassxc
      thunderbird
      tor-browser-bundle-bin

      nur.repos.qenya.digitalalovestory-bin
    ];
    programs.chromium.enable = true;

    home.stateVersion = "23.11";
  };
}
