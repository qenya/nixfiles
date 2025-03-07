{ config, lib, pkgs }:

{
  randomcat.services.zfs.datasets = {
    "rpool/state" = { mountpoint = "none"; };
    "rpool/state/netbox" = { mountpoint = "/var/lib/netbox"; };
  };

  services.netbox = {
    enable = true;
    package = pkgs.netbox_4_1;
    port = 8001;
    dataDir = "/var/lib/netbox";
    secretKeyFile = ""; #
  };
}
