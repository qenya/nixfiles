{ config, lib, pkgs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.editor = false;
    loader.efi.canTouchEfiVariables = true;

    initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
    kernelModules = [ "kvm-intel" ];

    supportedFilesystems = [ "ntfs" ]; # for USB drives
  };
}
