{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkForce;
in
{
  imports = [
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "elucredassa";
  networking.hostId = "a8ec6755";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  qenya.base-server.enable = true;

  time.timeZone = "Europe/London"; # Etc/UTC?
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  fountain.users.qenya.enable = true;
  users.users.qenya.extraGroups = [ "wheel" ];

  system.stateVersion = "24.11";
}
