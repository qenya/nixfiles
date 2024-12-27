{ config, lib, pkgs, ... }:

{
  services.bind = {
    # enable = true;
    cacheNetworks = [ "10.127.0.0/16" "fd70:81ca:0f8f::/48" ];
    forwarders = [ ];
    listenOn = [ config.birdsong.hosts.yevaud.ipv4 ];
    listenOnIpv6 = [ config.birdsong.hosts.yevaud.ipv6 ];
    zones = {
      "birdsong.internal" = {
        master = true;
        file = pkgs.writeText "birdsong.internal.zone" ''
          $TTL 60
          $ORIGIN birdsong.internal.

          birdsong.internal. IN SOA ns.birdsong.internal. auto.qenya.tel. ( 2024122701 7200 3600 1209600 3600 )
          birdsong.internal. IN NS ns.birdsong.internal.

          yevaud.c.birdsong.internal. IN A 10.127.1.1
          yevaud.c.birdsong.internal. IN AAAA fd70:81ca:0f8f:1::1

          ns.birdsong.internal. IN A 10.127.1.1
          ns.birdsong.internal. IN AAAA fd70:81ca:0f8f:1::1
        '';
      };
    };
  };
  networking.resolvconf.useLocalResolver = false;
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
