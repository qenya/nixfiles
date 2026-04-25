{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "tehanu";
  networking.hostId = "8e1185ab";

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];

  qenya.base-server.enable = true;

    randomcat.services.zfs.datasets = {
    "rpool_tehanu/state" = { mountpoint = "none"; };
    "rpool_tehanu/state/cfssl" = { mountpoint = config.services.cfssl.dataDir; };
    "rpool_tehanu/state/etcd" = { mountpoint = config.services.etcd.dataDir; };
    "rpool_tehanu/state/kubernetes" = { mountpoint = config.services.kubernetes.dataDir; };
  };

  services.sanoid.datasets."rpool_tehanu/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "100.77.194.23"; # tehanu tailscale ip
    # apiserver.advertiseAddress = "100.77.194.23";
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 6443 2379 2380 10250 10259 10257 ];

  system.stateVersion = "23.11";
}
