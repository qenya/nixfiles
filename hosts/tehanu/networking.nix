{ config, lib, pkgs, ... }:

{
  networking.useNetworkd = true;
  networking.interfaces.enp0s6.useDHCP = true;
}
