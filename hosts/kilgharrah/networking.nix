{ config, lib, pkgs, ... }:

{
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp2s0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };
}
