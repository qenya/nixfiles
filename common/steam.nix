{ config, lib, pkgs, ... }:

{
  programs.steam = {
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.joycond.enable = config.programs.steam.enable;
}
