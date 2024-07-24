{ config, lib, pkgs, ... }:

let
  cfg = config.qenya.services.fonts;
  inherit (lib) mkIf mkEnableOption;
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
