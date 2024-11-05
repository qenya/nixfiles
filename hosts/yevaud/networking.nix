{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.interfaces.ens3.useDHCP = true;

  age.secrets.wireguard-peer-yevaud = {
    file = ../../secrets/wireguard-peer-yevaud.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-yevaud.path;
  };
}
