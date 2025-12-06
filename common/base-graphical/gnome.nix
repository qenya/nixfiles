{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkMerge mkOption types;
  cfg = config.qenya.base-graphical;
in
{
  config = mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    # TODO: agree on this with randomcat as it affects her too, since for some reason this is system-wide
    # environment.gnome.excludePackages = with pkgs.gnome; [
    #   pkgs.gnome-tour
    #   epiphany # GNOME Web
    #   geary
    #   gnome-calendar
    #   gnome-contacts
    #   gnome-music
    # ];
  };
}
