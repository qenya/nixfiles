{ config, lib, pkgs, ... }:

{
  # SSD on board

  boot.initrd.luks.devices = {
    "cryptroot".device = "/dev/disk/by-uuid/b414aaba-0a36-4135-a7e1-dc9489286acd";
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


  # HDD in bay

  environment.etc.crypttab.text = ''
    albion UUID=8a924f24-9b65-4f05-aeda-5b4080cc7aa1 /root/luks-albion.key
  '';

  randomcat.services.zfs.datasets = {
    "rpool_albion/data" = { mountpoint = "none"; };
    "rpool_albion/data/steam" = { mountpoint = "/home/qenya/.local/share/Steam"; };
    "rpool_albion/state" = { mountpoint = "none"; };
    "rpool_albion/state/audiobookshelf" = { mountpoint = "/var/lib/audiobookshelf"; };
    "rpool_albion/state/jellyfin" = { mountpoint = "/var/lib/jellyfin"; };
    "rpool_albion/state/navidrome" = { mountpoint = "/var/lib/navidrome"; };
    "rpool_albion/srv" = { mountpoint = "none"; };
    "rpool_albion/srv/audiobookshelf" = { mountpoint = "/srv/audiobookshelf"; };
    "rpool_albion/srv/ftp" = { mountpoint = "/srv/ftp"; };
    "rpool_albion/srv/jellyfin" = { mountpoint = "/srv/jellyfin"; };
    "rpool_albion/srv/music" = { mountpoint = "/srv/music"; };
  };


  # Other

  boot.supportedFilesystems = [ "ntfs" "zfs" ];
}
