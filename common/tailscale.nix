{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--login-server" "https://headscale.unspecified.systems" ];
    extraDaemonFlags = [ "--no-logs-no-support" ]; # disable telemetry
  };

  systemd.services.tailscaled-autoconnect = {
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      sleep 2 # wait for tailscaled to settle
      ${lib.getExe config.services.tailscale.package} up --reset ${lib.escapeShellArgs config.services.tailscale.extraUpFlags}
    '';
  };

  networking.domain = "birdsong.network";

  # Workaround for: https://github.com/tailscale/tailscale/issues/16966
  nixpkgs.overlays = [
    (_: prev: {
      tailscale = prev.tailscale.overrideAttrs (old: {
        checkFlags =
          builtins.map
            (
              flag:
              if prev.lib.hasPrefix "-skip=" flag
              then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
              else flag
            )
            old.checkFlags;
      });
    })
  ];
}
