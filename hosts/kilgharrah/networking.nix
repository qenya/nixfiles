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

  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
}
