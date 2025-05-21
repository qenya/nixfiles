{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.headscale;
in
{
  options.qenya.services.headscale = {
    enable = mkEnableOption "Headscale";
    domain = mkOption {
      type = types.str;
    };
    dataDir = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = {
        ${cfg.domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:32770/";
            proxyWebsockets = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.headscale = {
      enable = true;
      address = "0.0.0.0"; # required to disable built-in ACME client for some reason
      port = 32770;
      settings = {
        server_url = "https://${cfg.domain}:443";
        prefixes.allocation = "random";
        dns.magic_dns = false;

        # disable built-in ACME client
        tls_cert_path = null;
        tls_key_path = null;
      };
    };
  };
}
