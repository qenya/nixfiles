{ config, lib, pkgs, ... }:

{
  networking.interfaces.ens3.useDHCP = true;
}
