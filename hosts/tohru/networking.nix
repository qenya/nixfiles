{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  systemd.network.wait-online.enable = false;
  
  networking.networkmanager.enable = true;
}
