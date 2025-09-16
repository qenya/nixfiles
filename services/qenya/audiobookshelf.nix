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
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:8234/";

    services.audiobookshelf.enable = true;
    services.audiobookshelf.port = 8234;
  };
}
