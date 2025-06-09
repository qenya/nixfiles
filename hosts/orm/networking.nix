{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.interfaces.ens3.useDHCP = true;
}
