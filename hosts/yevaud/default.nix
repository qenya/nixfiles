{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix

    ./experiments/birdsong-dns.nix
    # TODO: this breaks external IPv6 somehow
    # ./experiments/pennykettle.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  networking.hostName = "yevaud";
  networking.hostId = "09673d65";
  networking.domain = "birdsong.network";

  fountain.users.qenya.enable = true;
  users.users.qenya.extraGroups = [ "wheel" ];
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
    domain = "git.qenya.tel";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "git.katherina.rocks" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel$request_uri";
      };
      "birdsong.network" = {
        forceSSL = true;
        enableACME = true;
        locations."/".return = "301 https://git.qenya.tel/qenya/birdsong/";
      };
    };
  };

  system.stateVersion = "23.11";
}
