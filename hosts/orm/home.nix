{ config, lib, pkgs, ... }:

{
  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ../../home/cli.nix
      ../../home/git.nix
      ../../home/zsh.nix
    ];

    home.stateVersion = "23.11";
  };
}
