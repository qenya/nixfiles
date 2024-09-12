{ config, lib, pkgs, osConfig, ... }:

let
  isPlasma = osConfig.services.desktopManager.plasma6.enable || osConfig.services.xserver.desktopManager.plasma5.enable;
in
{
  programs.plasma.enable = isPlasma;
  programs.plasma.overrideConfig = true;

  imports = [ ];
}
