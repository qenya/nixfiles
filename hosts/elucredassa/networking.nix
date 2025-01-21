{ config, lib, pkgs, ... }:

{
  systemd.network.enable = true;
  networking.useDHCP = false;
  
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0f1";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };

  birdsong.peering = {
    enable = true;
    privateKeyFile = "/etc/wireguard/privatekey";
    persistentKeepalive = 29;
  };
}
