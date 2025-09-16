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
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:8096/";
    services.jellyfin.enable = true;
  };
}
