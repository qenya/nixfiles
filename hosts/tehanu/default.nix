{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "tehanu";
  networking.hostId = "8e1185ab";
  networking.domain = "birdsong.network";

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];

  qenya.base-server.enable = true;

  system.stateVersion = "23.11";
}
