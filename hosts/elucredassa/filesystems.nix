{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "luks-rpool-elucredassa".device = "/dev/disk/by-uuid/5ece5b58-c57a-41ae-b086-03707c39c9a7";
  };

  fileSystems = {
    "/" = {
      device = "rpool_elucredassa/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2519-E2D6";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/c7c48325-e90d-414d-b579-84cb45616ee9"; }];

  boot.supportedFilesystems = [ "ntfs" ]; # for USB drives
}
