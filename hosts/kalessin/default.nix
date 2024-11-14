{ config, lib, pkgs, ... }:

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

  fountain.users.trungle.enable = true;

  qenya.base-server.enable = true;

  system.stateVersion = "23.11";
}
