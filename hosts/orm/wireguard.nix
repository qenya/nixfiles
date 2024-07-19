{ config, lib, pkgs, ... }:

{
  age.secrets.wireguard-hub.file = ../../secrets/wireguard-hub.age;

  networking = {
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };

    firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];

    wireguard.interfaces.wg0 = {
      ips = [ "10.127.1.1/24" "fd70:81ca:0f8f:1::1/64" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard-hub.path;
      peers = [
        {
          name = "shaw";
          publicKey = "eD79pROC2zjhKz4tGRS43O95gcFRqO+SFb2XDnTr0zc=";
          allowedIPs = [ "10.127.1.2" "fd70:81ca:0f8f:1::2" ];
        }
        {
          name = "tohru";
          publicKey = "lk3PCQM1jmZoI8sM/rWSyKNuZOUnjox3n9L9geJD+18=";
          allowedIPs = [ "10.127.1.3" "fd70:81ca:0f8f:1::3" ];
        }
      ];
    };
  };
}
