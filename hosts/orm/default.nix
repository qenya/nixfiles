{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "orm";
  networking.hostId = "00000000";

  fountain.users.qenya.enable = true;
  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  randomcat.services.zfs.datasets = {
    "rpool_orm/state" = { mountpoint = "none"; };
    "rpool_orm/state/actual" = { mountpoint = "/var/lib/actual"; };
  };

  services.sanoid.datasets."rpool_orm/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  qenya.services.actual = {
    enable = true;
    domain = "actual.qenya.tel";
  };

  system.stateVersion = "23.11";
}
