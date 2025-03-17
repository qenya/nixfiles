{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.fountain.services.web-redirect;
in
{
  options.fountain.services.web-redirect = {
    enable = mkEnableOption "Module to do simple 301 redirects from one domain to another";
    domains = mkOption {
      type = types.attrsOf types.str;
      description = "Mapping from source domain to destination domain";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = builtins.mapAttrs
        (name: value: {
          forceSSL = true;
          enableACME = true;
          locations."/".return = "301 https://${value}$request_uri";
        })
        cfg.domains;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
