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
      discord
      foliate
      gimp-with-plugins
      keepassxc
      openttd
      thunderbird
      tor-browser-bundle-bin

      nur.repos.qenya.digital-a-love-story
    ];
    programs.chromium.enable = true;

    home.stateVersion = "23.11";
  };
}
