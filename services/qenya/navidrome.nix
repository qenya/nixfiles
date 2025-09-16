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
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:4533/";

    services.navidrome.enable = true;
    services.navidrome.settings = {
      MusicFolder = cfg.dataDir;
      BaseUrl = "https://${cfg.domain}";
    };
  };
}
