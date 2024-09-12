{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.qenya.services.pipewire.lowLatency;
in
{
  options.qenya.services.pipewire.lowLatency = {
    enable = mkEnableOption "config to decrease sound latency (increasing CPU load) for e.g. streaming";
    # TODO: might be an idea to have the numbers be configurable
  };

  config = mkIf cfg.enable {
    # TODO: needs more testing
    services.pipewire.extraConfig = {
      pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
      pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };
    # Available from NixOS 24.11. Lifted from https://nixos.wiki/wiki/PipeWire - probably need to adjust numbers
    # services.pipewire.wireplumber.extraLuaConfig.main."99-alsa-lowlatency" = ''
    #   alsa_monitor.rules = {
    #     {
    #       matches = {{{ "node.name", "matches", "alsa_output.*" }}};
    #       apply_properties = {
    #         ["audio.format"] = "S32LE",
    #         ["audio.rate"] = "96000", -- for USB soundcards it should be twice your desired rate
    #         ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
    #         -- ["api.alsa.disable-batch"] = true, -- generally, USB soundcards use the batch mode
    #       },
    #     },
    #   }
    # '';
  };
}
