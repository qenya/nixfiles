{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix

    ./experiments/pennykettle.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostName = "yevaud";
  networking.hostId = "09673d65";

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];
  qenya.base-server.enable = true;

  qenya.services.distributed-builds = {
    enable = true;
    keyFile = "/etc/ssh/ssh_host_ed25519_key";
    builders = [ "kilgharrah" ];
  };
  nix.settings.max-jobs = 0;

  randomcat.services.zfs.datasets = {
    "rpool/state" = { mountpoint = "none"; };
  };

  services.sanoid.datasets."rpool/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  system.stateVersion = "23.11";
}
