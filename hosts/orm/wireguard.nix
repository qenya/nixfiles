{ config, lib, pkgs, ... }:

{
  age.secrets.wireguard-hub.file = ../../secrets/wireguard-hub.age;

  birdsong.peer = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-hub.path;
  };
}
