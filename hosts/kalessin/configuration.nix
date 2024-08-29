{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.sysadmin.enable = true;

  system.stateVersion = "23.11";
}
