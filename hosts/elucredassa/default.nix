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

  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  # These are populated by fountain.backup
  randomcat.services.zfs.datasets = {
    "rpool_elucredassa/backup" = { mountpoint = "none"; };
    "rpool_elucredassa/backup/kalessin" = { mountpoint = "none"; };
    "rpool_elucredassa/backup/orm" = { mountpoint = "none"; };
  };

  qenya.services.distributed-builds = {
    enable = true;
    keyFile = "/etc/ssh/ssh_host_ed25519_key";
    builders = [ "kilgharrah" ];
  };

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];

  system.stateVersion = "24.11";
}
