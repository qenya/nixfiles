{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.fountain.services.reverse-proxy;
in
{
  options.fountain.services.reverse-proxy = {
    enable = mkEnableOption "Module to use nginx as a reverse proxy";
    domains = mkOption {
      type = types.attrsOf types.str;
      description = "Mapping from external domain to internal address";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = builtins.mapAttrs
        (name: value: {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = value;
            proxyWebsockets = true;
          };
        })
        cfg.domains;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
