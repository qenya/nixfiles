{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  age.secrets.wireguard-peer-yevaud.file = ../../secrets/wireguard-peer-yevaud.age;

  birdsong.peer = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-yevaud.path;
  };

  qenya.services.forgejo = {
    enable = true;
    domain = "git.qenya.tel";
    stateDir = "/data/forgejo";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.katherina.rocks" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel$request_uri";
      };
    };
  };

  system.stateVersion = "23.11";
}
