{ config, lib, pkgs, ... }:

let
  cfg = config.qenya.services.steam;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.qenya.services.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    services.joycond.enable = true;
  };
}
