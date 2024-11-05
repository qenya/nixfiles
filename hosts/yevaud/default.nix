{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostName = "yevaud";
  networking.hostId = "09673d65";

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  services.bind = {
    # enable = true;
    cacheNetworks = [ "10.127.0.0/16" "fd70:81ca:0f8f::/48" ];
    forwarders = [ ];
    listenOn = [ config.birdsong.hosts.yevaud.ipv4 ];
    listenOnIpv6 = [ config.birdsong.hosts.yevaud.ipv6 ];
    zones = {
      "birdsong.internal" = {
        master = true;
        # TODO: pick better email address for SOA record
        file = pkgs.writeText "birdsong.internal.zone" ''
          $TTL 60
          $ORIGIN birdsong.internal.

          birdsong.internal. IN SOA ns.birdsong.internal. accounts.katherina.rocks. ( 2024080401 7200 3600 1209600 3600 )
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

  randomcat.services.zfs.datasets = {
    "rpool/state" = { mountpoint = "none"; };
    "rpool/state/forgejo" = { mountpoint = "/var/lib/forgejo"; };
  };

  qenya.services.forgejo = {
    enable = true;
    domain = "git.qenya.tel";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.katherina.rocks" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel$request_uri";
      };
      "birdsong.network" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel/qenya/birdsong/";
      };
    };
  };

  system.stateVersion = "23.11";
}
