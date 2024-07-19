{ config, lib, pkgs, ... }:

{
  age.secrets.wireguard-peer-tohru.file = ../../secrets/wireguard-peer-tohru.age;

  networking = {
    firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];

    wireguard.interfaces.wg0 = {
      ips = [ "10.127.1.3/24" "fd70:81ca:0f8f:1::3/64" ];
      listenPort = 51821;
      privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
      peers = [
        {
          publicKey = "birdLVh8roeZpcVo308Ums4l/aibhAxbi7MBsglkJyA=";
          allowedIPs = [ "10.127.1.0/24" "fd70:81ca:0f8f:1::/64" ];
          endpoint = "birdsong.network:51820";
          persistentKeepalive = 23;
        }
      ];
    };
  };
}
