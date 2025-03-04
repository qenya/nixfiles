{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "orm";
  networking.hostId = "00000000";
  networking.domain = "birdsong.network";

  fountain.users.qenya.enable = true;
  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  qenya.services.distributed-builds = {
    enable = true;
    keyFile = "/etc/ssh/ssh_host_ed25519_key";
    builders = [ "kilgharrah" ];
  };
  nix.settings.max-jobs = 0;

  randomcat.services.zfs.datasets = {
    "rpool_orm/state" = { mountpoint = "none"; };
    "rpool_orm/state/actual" = { mountpoint = "/var/lib/actual"; };
  };

  services.sanoid.datasets."rpool_orm/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
    process_children_only = true;
  };

  qenya.services.actual.enable = true;

  system.stateVersion = "23.11";
}
