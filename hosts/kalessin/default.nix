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
  fountain.users.randomcat.enable = true;
  fountain.users.trungle.enable = true;
  fountain.admins = [ "qenya" "randomcat" ];

  qenya.base-server.enable = true;

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [ ];
  };

  randomcat.services.zfs.datasets = {
    "rpool_kalessin/state" = { mountpoint = "none"; };
    "rpool_kalessin/state/headscale" = { mountpoint = "/var/lib/headscale"; };
    "rpool_kalessin/state/owncast" = { mountpoint = "/var/lib/owncast"; };
  };

  services.sanoid.datasets."rpool_kalessin/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  qenya.services.owncast = {
    enable = true;
    domain = "live.qenya.tel";
    dataDir = "/var/lib/owncast";
  };

  qenya.services.headscale = {
    enable = true;
    domain = "headscale.unspecified.systems";
    dataDir = "/var/lib/headscale";
  };

  system.stateVersion = "23.11";
}
