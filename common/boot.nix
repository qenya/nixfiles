{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf optionals;
in
{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.editor = false;
    systemd-boot.memtest86.enable = mkIf config.nixpkgs.hostPlatform.isx86 true;
    efi.canTouchEfiVariables = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "2001:67c:930::1#wikimedia-dns.org"
        "185.71.138.138#wikimedia-dns.org"
      ];
      DNSOverTLS = true;
      FallbackDNS = [ ];
    };
  };
}
