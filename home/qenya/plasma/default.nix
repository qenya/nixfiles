{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf;
  isPlasma = osConfig.services.desktopManager.plasma6.enable || osConfig.services.xserver.desktopManager.plasma5.enable;
in
{
  # FIXME: this mkIf is necessary because home/qenya is imported into shaw here:
  #  https://github.com/randomnetcat/nix-configs/blob/75d491dc6904475e43a820287edf3cf2f89abcfb/hosts/shaw/birdsong.nix#L74
  #  shaw doesn't understand programs.plasma because randomcat doesn't import
  #  plasma-manager, and is unwilling to because none of her machines run KDE.
  #  This probably can't be fixed until we merge our configs completely.
  programs = mkIf isPlasma {
    plasma.enable = isPlasma;
    plasma.overrideConfig = true;
  };

  imports = [ ];
}
