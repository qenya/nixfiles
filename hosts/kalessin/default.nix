{ config, lib, pkgs, ... }:

let
  keys = import ../../keys.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "kalessin";
  networking.hostId = "534b538e";

  fountain.users.qenya.enable = true;
  users.users.qenya.extraGroups = [ "wheel" ];
  fountain.users.randomcat.enable = true;
  fountain.users.trungle.enable = true;

  qenya.base-server.enable = true;

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [ ];
  };

  system.stateVersion = "23.11";
}
