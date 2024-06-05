{ config, lib, pkgs, ... }:

{
  imports = [
    ../../services/nginx.nix
  ];

  # TODO: ssh access
  # TODO: email out
  # TODO: interface customisation

  services.nginx.virtualHosts = {
    # TODO: move to new domain
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
}
