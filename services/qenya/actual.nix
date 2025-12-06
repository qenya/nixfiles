{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.actual;
in
{
  options.qenya.services.actual = {
    enable = mkEnableOption "Actual Budget";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:5006/";

    services.actual = {
      enable = true;
      settings.port = 5006;
    };
  };
}
