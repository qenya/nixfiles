{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../services/nginx.nix
      ../../services/openssh.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.nginx.virtualHosts = {
    "git.katherina.rocks" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://[::1]:3000/";
    };
  };

  services.forgejo = {
    enable = true;
    stateDir = "/data/forgejo";
    settings = {
      DEFAULT.APP_NAME = "git.katherina.rocks";
      cache = {
        ADAPTER = "twoqueue";
        HOST = ''{"size": 100, "recent_ratio": 0.25, "ghost_ratio": 0.5}'';
      };
      database = {
        DB_TYPE = "sqlite3";
        SQLITE_JOURNAL_MODE = "WAL";
      };
      security.LOGIN_REMEMBER_DAYS = 365;
      server = {
        DOMAIN = "git.katherina.rocks";
        HTTP_PORT = 3000;
        ROOT_URL = "https://git.katherina.rocks/";
      };
      service.DISABLE_REGISTRATION = true;
    };
  };

  system.stateVersion = "23.11";

}

