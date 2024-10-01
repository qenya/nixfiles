{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "rpool".device = "/dev/nvme0n1p2";
  };

  boot.supportedFilesystems = [ "ntfs" ]; # for USB drives

  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/var";
      fsType = "zfs";
    };
    "/config" = {
      device = "rpool/config";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
    "/data" = {
      device = "rpool/data";
      fsType = "zfs";
    };
    "/data/syncthing" = {
      device = "rpool/data/syncthing";
      fsType = "zfs";
    };
    "/data/steam" = {
      device = "rpool/data/steam";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/7DD4-487E";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/a066313e-2467-4e07-ad0c-aeb7ff3f8d97"; }];
}
