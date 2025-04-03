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
    "rpool_kalessin/state/kanidm" = { mountpoint = "/var/lib/kanidm"; };
  };

  services.sanoid.datasets."rpool_kalessin/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
    process_children_only = true;
  };

  fountain.services.kanidm = {
    enable = true;
    domain = "auth.unspecified.systems";
  };

  system.stateVersion = "23.11";
}
