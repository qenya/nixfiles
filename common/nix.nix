{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.flake = {
    source = lib.cleanSource pkgs.path;
    setNixPath = true;
    setFlakeRegistry = true;
  };
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "@wheel" ];
}
