{ config, lib, pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
  };
  nix.optimise.automatic = true;
  services.fstrim.enable = true;
}