{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkForce;
in
{
  services.xserver.displayManager.gdm.enable = mkForce false;
  services.xserver.desktopManager.gnome.enable = mkForce false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    programs.plasma.enable = true;
    programs.plasma.overrideConfig = true;

    # For the moment, this hosts some network-accessible services, so we want it on 24/7
    programs.plasma.powerdevil.AC.autoSuspend.action = "nothing";
  };
}
