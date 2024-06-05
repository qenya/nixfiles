{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/btop.nix
      ../../home/cli.nix
    ];

    home.stateVersion = "23.11";
  };
}
