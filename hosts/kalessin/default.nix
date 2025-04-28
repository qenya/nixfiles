{ config, lib, pkgs, ... }:

let
  keys = import ../../keys.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "kalessin";
  networking.hostId = "534b538e";
  networking.domain = "birdsong.network";

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];
  fountain.users.randomcat.enable = true;
  fountain.users.trungle.enable = true;

  qenya.base-server.enable = true;

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [ ];
  };

  randomcat.services.zfs.datasets = {
    "rpool_kalessin/state" = { mountpoint = "none"; };
    "rpool_kalessin/state/owncast" = { mountpoint = "/var/lib/owncast"; };
  };

  services.sanoid.datasets."rpool_kalessin/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
    process_children_only = true;
  };

  qenya.services.owncast = {
    enable = true;
    domain = "live.qenya.tel";
    dataDir = "/var/lib/owncast";
  };

  system.stateVersion = "23.11";
}
