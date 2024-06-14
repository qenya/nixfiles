{ config, lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services.joycond.enable = true;

  # Currently broken: 
  # environment.systemPackages = with pkgs; [
  #   itch
  # ];
}