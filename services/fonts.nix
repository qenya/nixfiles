{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.fonts;
in
{
  options.qenya.services.fonts = {
    enable = mkEnableOption "Fonts";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      corefonts
    ];
  };
}
