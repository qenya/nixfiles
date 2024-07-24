{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.services.steam;
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
