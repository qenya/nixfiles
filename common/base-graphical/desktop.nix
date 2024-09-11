{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config.qenya.base-graphical;

  isGnome = cfg.desktop == "gnome";
  isPlasma6 = cfg.desktop == "plasma6";
in
{
  options.qenya.base-graphical.desktop = mkOption {
    type = types.enum [ "gnome" "plasma6" ];
    default = "gnome";
    example = "plasma6";
    description = "Which display manager and desktop manager to use.";
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = isGnome;
    services.xserver.desktopManager.gnome.enable = isGnome;

    services.displayManager.sddm.enable = isPlasma6;
    services.displayManager.sddm.wayland.enable = isPlasma6;
    services.desktopManager.plasma6.enable = isPlasma6;
  };
}
