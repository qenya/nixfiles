{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  systemd.network.wait-online.enable = false;
  
  networking.networkmanager.enable = true;

  age.secrets.wireguard-peer-tohru = {
    file = ../../secrets/wireguard-peer-tohru.age;
    owner = "root";
    group = "systemd-network";
    mode = "640";
  };
  
  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
    persistentKeepalive = 23;
  };
}
