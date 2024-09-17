{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostId = "534b538e";
  deployment = {
    targetHost = "kalessin.birdsong.network";
    buildOnTarget = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  system.stateVersion = "23.11";
}
