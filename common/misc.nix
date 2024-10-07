{ config, lib, pkgs, ... }:

{
  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  services.fstrim.enable = true;
}