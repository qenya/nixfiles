{ config, lib, pkgs, ... }:

{
  environment.etc.crypttab.text = ''
    albion UUID=acda0e7a-069f-47c7-8e37-ec00e7cdde0f /root/luks-albion.key
  '';

  randomcat.services.zfs.datasets = {
    "rpool_albion/data" = { mountpoint = "none"; };
    "rpool_albion/data/steam" = { mountpoint = "/home/qenya/.local/share/Steam"; };
  };
}
