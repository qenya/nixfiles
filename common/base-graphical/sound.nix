{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.base-graphical;
in
{
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    services.pulseaudio.enable = false; # this theoretically defaults to false but something else seems to be flipping it
    environment.systemPackages = with pkgs; [ helvum ]; # patchbay
  };
}
