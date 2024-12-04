{ config, lib, pkgs, ... }:

{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-pennykettle1" ];
  networking.nat.externalInterface = "ens3";
  networking.firewall.allowedUDPPorts = [ 51821 ];

  containers."pennykettle1" = {
    privateNetwork = true;
    extraVeths."ve-pennykettle1" = {
      hostAddress = "10.235.1.1";
      localAddress = "10.235.2.1";
      forwardPorts = [{ hostPort = 51821; }];
    };
    ephemeral = true;
    autoStart = true;
    bindMounts."/run/secrets/wg-key".hostPath = config.age.secrets.protonvpn-pennykettle1.path;

    config = { config, pkgs, ... }: {
      system.stateVersion = "24.05";
      systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
      environment.systemPackages = [ pkgs.wireguard-tools ];

      networking.useDHCP = false;
      networking.useHostResolvConf = false;
      networking.firewall.allowedUDPPorts = [ 51821 ];
      systemd.network = {
        enable = true;

        networks."10-ve" = {
          matchConfig.Name = "ve-pennykettle1";
          networkConfig.Address = "10.235.2.1/32";
          # linkConfig.RequiredForOnline = "routable";
          routes = [{
            routeConfig = {
              Gateway = "10.235.1.1";
              Destination = "217.138.216.162/32";
            };
          }];
        };

        networks."30-protonvpn" = {
          matchConfig.Name = "wg-protonvpn";
          networkConfig = {
            DefaultRouteOnDevice = true;
            Address = [ "10.2.0.2/32" ];
            DNS = "10.2.0.1";
          };
          linkConfig = {
            RequiredForOnline = "yes";
            ActivationPolicy = "always-up";
          };
        };

        netdevs."30-protonvpn" = {
          netdevConfig = {
            Name = "wg-protonvpn";
            Kind = "wireguard";
            Description = "WireGuard tunnel to ProtonVPN (DE#1; NAT: strict, no port forwarding)";
          };
          wireguardConfig = {
            ListenPort = 51821;
            PrivateKeyFile = "/run/secrets/wg-key";
          };
          wireguardPeers = [{
            wireguardPeerConfig = {
              PublicKey = "C+u+eQw5yWI2APCfVJwW6Ovj3g4IrTOfe+tMZnNz43s=";
              AllowedIPs = "0.0.0.0/0";
              Endpoint = "217.138.216.162:51820";
              PersistentKeepalive = 5;
            };
          }];
        };
      };
    };
  };

  age.secrets.protonvpn-pennykettle1 = {
    file = ../../../secrets/protonvpn-pennykettle1.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };
}