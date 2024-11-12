{ config, lib, pkgs, ... }:

{
  systemd.network.enable = true;
  networking.useDHCP = false;
  
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp2s0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };

  age.secrets.wireguard-peer-kilgharrah = {
    file = ../../secrets/wireguard-peer-kilgharrah.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-kilgharrah.path;
    persistentKeepalive = 31;
  };
}
