{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.fountain.services.kanidm;
in
{
  options.fountain.services.kanidm = {
    enable = mkEnableOption "Kanidm";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services = {
      nginx = {
        enable = true;
        virtualHosts = {
          ${cfg.domain} = {
            forceSSL = true;
            useACMEHost = cfg.domain;
            locations."/".proxyPass = "https://[::1]:8443/";
          };
        };
      };

      kanidm = {
        enableClient = true; # needed for admin configuration
        enableServer = true;
        package = pkgs.kanidm_1_5;
        serverSettings = {
          bindaddress = "[::1]:8443";
          ldapbindaddress = "[::1]:636";
          origin = "https://${cfg.domain}";
          domain = cfg.domain;
          tls_chain = "${config.security.acme.certs.${cfg.domain}.directory}/fullchain.pem";
          tls_key = "${config.security.acme.certs.${cfg.domain}.directory}/key.pem";
          online_backup.versions = 7;
          trust_x_forward_for = true;
        };
        clientSettings.uri = config.services.kanidm.serverSettings.origin; # doesn't like connecting through localhost - wants hostname to match
      };
    };

    security.acme.certs.${cfg.domain} = {
      webroot = "/var/lib/acme/acme-challenge";
      group = "acme_${cfg.domain}";
      reloadServices = [ "kanidm.service" ];
    };

    users.groups."acme_${cfg.domain}".members = [
      "kanidm"
      config.services.nginx.user
    ];

    networking.firewall.allowedTCPPorts = [ 80 443 636 ];
  };
}
