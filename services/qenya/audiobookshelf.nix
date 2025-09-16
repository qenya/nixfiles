{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.audiobookshelf;
in
{
  options.qenya.services.audiobookshelf = {
    enable = mkEnableOption "Audiobookshelf";
    domain = mkOption {
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
            proxyPass = "http://127.0.0.1:8234/";
            proxyWebsockets = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.audiobookshelf.enable = true;
    services.audiobookshelf.port = 8234;
  };
}
