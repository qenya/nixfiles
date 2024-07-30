{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  age.secrets.wireguard-peer-yevaud.file = ../../secrets/wireguard-peer-yevaud.age;

  birdsong.peering = {
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
      "birdsong.network" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel/qenya/birdsong/";
      };
    };
  };

  system.stateVersion = "23.11";
}
