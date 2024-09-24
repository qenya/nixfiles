{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.programs.steam.enable {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    services.joycond.enable = true;
  };
}
