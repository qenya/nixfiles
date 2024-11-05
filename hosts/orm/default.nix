{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "orm";
  networking.hostId = "00000000";

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  age.secrets.wireguard-peer-orm = {
    file = ../../secrets/wireguard-peer-orm.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-orm.path;
  };

  randomcat.services.zfs.datasets = {
    "rpool_orm/state" = { mountpoint = "none"; };
    "rpool_orm/state/actual" = { mountpoint = "/var/lib/actual"; };
  };

  qenya.services.actual = {
    enable = true;
    domain = "actual.qenya.tel";
  };

  system.stateVersion = "23.11";
}
