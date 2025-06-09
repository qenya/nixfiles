{ config, lib, pkgs, ... }:

{
  systemd.network.enable = true;
  networking.useDHCP = false;

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0f1";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
      Tunnel = "sit-he-ipv6";
    };
    linkConfig.RequiredForOnline = "routable";
  };

  systemd.network.netdevs."25-he-ipv6" = {
    netdevConfig = {
      Name = "sit-he-ipv6";
      Kind = "sit";
      Description = "Hurricane Electric IPv6 Tunnel";
      MTUBytes = 1480;
    };

    tunnelConfig = {
      Remote = "216.66.88.98";
      TTL = 255;
    };
  };

  systemd.network.networks."25-he-ipv6" = {
    matchConfig.Name = "sit-he-ipv6";
    networkConfig.Address = [ "2001:470:1f1c:3e::2/64" ];
    routes = [{ Destination = [ "::/0" ]; }];
  };
}
