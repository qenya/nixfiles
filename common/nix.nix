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

  # this is a dependency of feishin (used in qenya's home-manager). it does not actually have a known vulnerability,
  # it's just unsuspported because Electron's support cycle is a ludicrously short 6 months.
  # feishin's dev is going to be rewriting it without Electron (as "audioling").
  # modern software development was a mistake.
  nixpkgs.config.permittedInsecurePackages = [
    "electron-31.7.7"
  ];
}
