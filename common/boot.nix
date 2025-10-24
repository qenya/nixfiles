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
    fallbackDns = [ ];
    dnsovertls = "true";
    extraConfig = ''
      DNS=2a07:e340::4#base.dns.mullvad.net 194.242.2.4#base.dns.mullvad.net
    '';
  };
}
