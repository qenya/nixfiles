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
}
