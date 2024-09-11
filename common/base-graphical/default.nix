{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.base-graphical;
in
{
  imports = [
    ./desktop.nix
    ./sound.nix
  ];

  options.qenya.base-graphical.enable = mkEnableOption "Base configuration for graphical environments";

  config = mkIf cfg.enable {
    services.xserver.enable = true;
  };
}
