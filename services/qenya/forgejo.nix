{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.forgejo;
in
{
  options.qenya.services.forgejo = {
    enable = mkEnableOption "Forgejo";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    # TODO: email out
    # TODO: interface customisation

    services = {
      nginx = {
        enable = true;
        virtualHosts = {
          ${cfg.domain} = {
            forceSSL = true;
            enableACME = true;
            locations."/".proxyPass = "http://[::1]:3000/";
          };
        };
      };

      forgejo = {
        enable = true;
        settings = {
          DEFAULT.APP_NAME = cfg.domain;
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
            DOMAIN = cfg.domain;
            HTTP_PORT = 3000;
            ROOT_URL = "https://${cfg.domain}/";
          };
          service.DISABLE_REGISTRATION = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
