{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.actual;
  domain = "actual.qenya.tel";
in
{
  options.qenya.services.actual = {
    enable = mkEnableOption "Actual Budget";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts = {
        ${domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://127.0.0.1:5006/";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.actual.enable = true;
  };
}
