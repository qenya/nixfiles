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
    "rpool/state/forgejo" = { mountpoint = "/var/lib/forgejo"; };
  };

  services.sanoid.datasets."rpool/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  qenya.services.forgejo = {
    enable = true;
    domain = "git.unspecified.systems";
  };
  fountain.services.web-redirect = {
    enable = true;
    domains = {
      "git.katherina.rocks" = "git.unspecified.systems";
      "git.qenya.tel" = "git.unspecified.systems";
    };
  };

  system.stateVersion = "23.11";
}
