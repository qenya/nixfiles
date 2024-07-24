{ config, lib, pkgs, ... }:

{
  age.secrets.wireguard-peer-tohru.file = ../../secrets/wireguard-peer-tohru.age;

  birdsong.peer = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
    listenPort = 51821;
    persistentKeepalive = 23;
  };

  # TODO: get this from a list of peers, keyed on hostname
  networking.wireguard.interfaces.birdsong.ips = [ "10.127.1.3/24" "fd70:81ca:0f8f:1::3/64" ];
}
