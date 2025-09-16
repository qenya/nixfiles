{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.jellyfin;
in
{
  options.qenya.services.jellyfin = {
    enable = mkEnableOption "Jellyfin";
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
          locations."/".proxyPass = "http://127.0.0.1:8096/";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.jellyfin.enable = true;
  };
}
