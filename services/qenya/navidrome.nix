{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.navidrome;
in
{
  options.qenya.services.navidrome = {
    enable = mkEnableOption "Navidrome";
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
          locations."/".proxyPass = "http://127.0.0.1:4533/";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.navidrome.enable = true;
    services.navidrome.settings = {
      MusicFolder = cfg.dataDir;
      BaseUrl = "https://${cfg.domain}";
    };
  };
}
