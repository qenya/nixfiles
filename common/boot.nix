{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
in
{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.editor = false;
    systemd-boot.memtest86.enable = mkIf config.nixpkgs.hostPlatform.isx86 true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPatches = [
    # Fix the /proc/net/tcp seek issue
    # Impacts tailscale: https://github.com/tailscale/tailscale/issues/16966
    {
      name = "proc: fix missing pde_set_flags() for net proc files";
      patch = pkgs.fetchurl {
        name = "fix-missing-pde_set_flags-for-net-proc-files.patch";
        url = "https://patchwork.kernel.org/project/linux-fsdevel/patch/20250821105806.1453833-1-wangzijie1@honor.com/raw/";
        hash = "sha256-DbQ8FiRj65B28zP0xxg6LvW5ocEH8AHOqaRbYZOTDXg=";
      };
    }
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [ ];
    dnsovertls = "true";
    extraConfig = ''
      DNS=2a07:e340::4#base.dns.mullvad.net 194.242.2.4#base.dns.mullvad.net 2606:1a40::11#p2.freedns.controld.com 76.76.2.11#p2.freedns.controld.com
    '';
  };
}
