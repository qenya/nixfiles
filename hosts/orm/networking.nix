{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.interfaces.ens3.useDHCP = true;

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
}
