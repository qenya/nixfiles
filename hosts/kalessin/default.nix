{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "kalessin";
  networking.hostId = "534b538e";

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  system.stateVersion = "23.11";
}
