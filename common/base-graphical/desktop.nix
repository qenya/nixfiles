{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge mkOption types;
  cfg = config.qenya.base-graphical;
in
{
  options.qenya.base-graphical.desktop = mkOption {
    type = types.enum [ "gnome" "plasma6" ];
    default = "gnome";
    example = "plasma6";
    description = "Which display manager and desktop manager to use.";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.desktop == "gnome") {
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      # TODO: agree on this with randomcat as it affects her too, since for some reason this is system-wide
      # environment.gnome.excludePackages = with pkgs.gnome; [
      #   pkgs.gnome-tour
      #   epiphany # GNOME Web
      #   geary
      #   gnome-calendar
      #   gnome-contacts
      #   gnome-music
      # ];
    })
    (mkIf (cfg.desktop == "plasma6") {
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
    })
  ]);
}
