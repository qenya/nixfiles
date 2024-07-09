{ config, lib, pkgs, ... }:

{
  # TODO: email out
  # TODO: interface customisation

  services = {
    nginx = {
      enable = true;
      virtualHosts = {
        "git.qenya.tel" = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://[::1]:3000/";
        };
        "git.katherina.rocks" = {
          forceSSL = true;
          enableACME = true;
          locations."/".return = "301 https://git.qenya.tel$request_uri";
        };
      };
    };

    forgejo = {
      enable = true;
      stateDir = "/data/forgejo";
      settings = {
        DEFAULT.APP_NAME = "git.qenya.tel";
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
          DOMAIN = "git.qenya.tel";
          HTTP_PORT = 3000;
          ROOT_URL = "https://git.qenya.tel/";
        };
        service.DISABLE_REGISTRATION = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
