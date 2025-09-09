{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.programs.steam.enable {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      extest.enable = true;
      protontricks.enable = true;
    };

    services.joycond.enable = true;
  };
}
