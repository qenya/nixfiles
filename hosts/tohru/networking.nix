{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  age.secrets.wireguard-peer-tohru.file = ../../secrets/wireguard-peer-tohru.age;
  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
    persistentKeepalive = 23;
  };
}
