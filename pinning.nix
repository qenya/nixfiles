{ config, lib, pkgs, ... }:

let sources = import ./npins;
in {
  # Make <nixpkgs> point systemwide to the pinned nixpkgs
  # https://jade.fyi/blog/pinning-nixos-with-npins/
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.flake.source = sources.nixpkgs;
  nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
}
