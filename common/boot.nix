{ config, lib, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.editor = false;
    systemd-boot.memtest86.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
