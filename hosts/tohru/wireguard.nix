{ config, lib, pkgs, ... }:

{
  age.secrets.wireguard-peer-tohru.file = ../../secrets/wireguard-peer-tohru.age;

  birdsong.peer = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
    persistentKeepalive = 23;
  };
}
