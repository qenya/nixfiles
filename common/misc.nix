{ config, lib, pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
  services.fstrim.enable = true;
}