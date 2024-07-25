{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  age.secrets.wireguard-peer-orm.file = ../../secrets/wireguard-peer-orm.age;

  birdsong.peer = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-orm.path;
  };

  system.stateVersion = "23.11";
}
