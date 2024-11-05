{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.interfaces.enp0s6.useDHCP = true;

  age.secrets.wireguard-peer-kalessin = {
    file = ../../secrets/wireguard-peer-kalessin.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-kalessin.path;
  };
}
