{ config, lib, pkgs, ... }:

{
  networking.nat.enable = true;
  networking.nat.enableIPv6 = true;
  networking.nat.internalInterfaces = [ "ve-pennykettle1" ];
  networking.nat.externalInterface = "ens3";
  networking.nat.forwardPorts = [
    {
      sourcePort = 51821;
      destination = "[fc00::2]:51821";
      proto = "udp";
    }
  ];
  networking.firewall.allowedUDPPorts = [ 51821 ];

  containers."pennykettle1" = {
    privateNetwork = true;
    extraVeths."ve-pennykettle1" = {
      hostAddress = "10.231.136.1";
      localAddress = "10.231.136.2";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
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
          networkConfig.Address = [ "10.231.136.2/24" "fc00::2/64" ];
          linkConfig.RequiredForOnline = "yes";
          routes = [{
            Gateway = [ "10.231.136.1" "fc00::1" ];
            Destination = "217.138.216.162";
          }];
        };

        networks."30-protonvpn" = {
          matchConfig.Name = "wg-protonvpn";
          networkConfig = {
            Address = [ "10.2.0.2/32" ];
            DNS = "10.2.0.1";
          };
          linkConfig = {
            RequiredForOnline = "yes";
            ActivationPolicy = "always-up";
          };
          routes = [
            { Gateway = [ "0.0.0.0" ]; }
            { Gateway = [ "::" ]; } # TODO: ipv6 out is still not working for unclear reasons
          ];
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
            PublicKey = "C+u+eQw5yWI2APCfVJwW6Ovj3g4IrTOfe+tMZnNz43s=";
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
            Endpoint = "217.138.216.162:51820";
            PersistentKeepalive = 5;
          }];
        };
      };

      networking.nat.enable = true;
      networking.nat.enableIPv6 = true;
      networking.nat.internalInterfaces = [ "ve-pennykettle1" ];
      networking.nat.externalInterface = "wg-protonvpn";
    };
  };

  age.secrets.protonvpn-pennykettle1 = {
    file = ../../../secrets/protonvpn-pennykettle1.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  # TODO: password-protect the proxy instead of relying on only listening over Tailscale
  services.microsocks = {
    enable = true;
    port = 1080;
    ip = "::";
    outgoingBindIp = "fc00::2";
    # authUsername = "testusername123";
    # authPasswordFile = pkgs.writeText "testpassword" "testpassworddonotuse";
    # execWrapper = "${lib.getExe pkgs.strace}";
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 1080 ];
}
