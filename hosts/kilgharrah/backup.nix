{ config, lib, pkgs, ... }:

{
  services.sanoid.datasets."rpool_albion/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };
}