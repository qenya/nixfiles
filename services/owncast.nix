{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.owncast;
in
{
  options.qenya.services.owncast = {
    enable = mkEnableOption "Owncast";
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
          locations."/".proxyPass = "http://127.0.0.1:8080/";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 1935 ]; # 1935 for rtmp

    services.owncast.enable = true;
    services.owncast.dataDir = cfg.dataDir;
  };
}
