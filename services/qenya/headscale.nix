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
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:32770/";

    services.headscale = {
      enable = true;
      address = "0.0.0.0"; # required to disable built-in ACME client for some reason
      port = 32770;
      settings = {
        server_url = "https://${cfg.domain}:443";
        prefixes.allocation = "random";
        dns = {
          magic_dns = true;
          base_domain = "birdsong.network";
        };

        # disable built-in ACME client
        tls_cert_path = null;
        tls_key_path = null;
      };
    };
  };
}
