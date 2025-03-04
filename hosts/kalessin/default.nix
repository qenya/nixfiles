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
  users.users.qenya.extraGroups = [ "wheel" ];
  fountain.users.randomcat.enable = true;
  fountain.users.trungle.enable = true;

  qenya.base-server.enable = true;

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [ ];
  };

  randomcat.services.zfs.datasets = {
    "rpool_kalessin/state" = { mountpoint = "none"; };
  };

  services.sanoid.datasets."rpool_kalessin/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
    process_children_only = true;
  };

  system.stateVersion = "23.11";
}
