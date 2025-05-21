{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--login-server" "https://headscale.unspecified.systems" ]; # TODO: doesn't work (nixos bug); needs connecting/specifying manually
    extraDaemonFlags = [ "--no-logs-no-support" ]; # disable telemetry
  };
}
