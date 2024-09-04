{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "enc".device = "/dev/disk/by-uuid/b414aaba-0a36-4135-a7e1-dc9489286acd";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };
    "/root" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@root" "compress=zstd" ];
    };
    "/srv" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@srv" "compress=zstd" ];
    };
    "/var/cache" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@cache" "compress=zstd" "noatime" ];
    };
    "/var/tmp" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@tmp" "compress=zstd" "noatime" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/ad4cbc18-8849-40ed-b0bf-097f8f46346b";
      fsType = "btrfs";
      options = [ "subvol=@log" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9582-E78D";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32 * 1024;
  }];
}
