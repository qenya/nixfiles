{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
  nixpkgs.config.allowUnfree = true;
}
