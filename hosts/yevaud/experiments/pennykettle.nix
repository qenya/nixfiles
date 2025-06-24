{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = config.networking.firewall.allowedTCPPorts ++ [ 1080 ];

  environment.systemPackages = [ pkgs.wireguard-tools ];
  networking.wireguard.interfaces."wg-protonvpn" = {
    ips = [ "10.2.0.2/32" ];
    peers = [{
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      endpoint = "217.138.216.162:51820";
      publicKey = "C+u+eQw5yWI2APCfVJwW6Ovj3g4IrTOfe+tMZnNz43s=";
    }];
    privateKeyFile = config.age.secrets.protonvpn-pennykettle1.path;
    listenPort = 51820;
    table = "957851094"; # randomly generated
  };

  networking.localCommands = ''
    ip rule add from 10.2.0.2/32 table 957851094
  '';
  networking.firewall.checkReversePath = "loose";

  age.secrets.protonvpn-pennykettle1 = {
    file = ../../../secrets/protonvpn-pennykettle1.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };

  services.dante = {
    enable = true;
    config = ''
      debug: 2
      internal: tailscale0
      external: wg-protonvpn

      # auth/tls handled by tailscale
      clientmethod: none
      socksmethod: none

      # allow connections from tailscale
      # "0/0" matches any v4 or v6 address
      client pass {
        from: 100.64.0.0/10 to: 0/0
        log: error connect disconnect
      }
      client pass {
        from: fd7a:115c:a1e0::/48 to: 0/0
        log: error connect disconnect
      }

      socks pass {
        from: 0/0 to: 0/0
        protocol: tcp udp
        log: error connect disconnect iooperation
      }
    '';
  };

  systemd.services.dante = {
    wants = [ "tailscaled-autoconnect.service" ];
    after = [ "tailscaled-autoconnect.service" ];
  };
}
