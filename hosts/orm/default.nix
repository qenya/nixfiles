{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "orm";
  networking.hostId = "00000000";
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
    "rpool_orm/state" = { mountpoint = "none"; };
    "rpool_orm/state/actual" = { mountpoint = "/var/lib/actual"; };
    "rpool_orm/state/postgresql" = { mountpoint = "/var/lib/postgresql"; };
  };

  services.sanoid.datasets."rpool_orm/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
    process_children_only = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/var/lib/postgresql/17";
    # managing imperatively instead of using ensureDatabases/ensureUsers

    enableTCPIP = true;
    settings = {
      port = 5432;
      ssl = true;
    };
    # only allow remote connections from within birdsong vpn
    # TODO: don't hardcode the IP addresses
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      host  sameuser  all     10.127.0.0/16 scram-sha-256
      host  sameuser  all     fd70:81ca:f8f::/48 scram-sha-256
    '';
  };
  networking.firewall.interfaces."wg-birdsong".allowedTCPPorts = [ 5432 ];

  qenya.services.actual.enable = true;

  system.stateVersion = "23.11";
}
