{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "orm";
  networking.hostId = "00000000";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.qenya.extraGroups = [ "wheel" ];
  qenya.base-server.enable = true;

  age.secrets.wireguard-peer-orm.file = ../../secrets/wireguard-peer-orm.age;

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-orm.path;
  };

  system.stateVersion = "23.11";
}
