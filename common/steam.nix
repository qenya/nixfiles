{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.programs.steam.enable {
    programs.steam = {
      package = pkgs.steam.override {
        extraArgs = "-pipewire"; # for remote play with PipeWire
      };

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    services.joycond.enable = true;
  };
}
