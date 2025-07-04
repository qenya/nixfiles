{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "orm";
  networking.hostId = "00000000";

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
    "rpool_orm/state" = { mountpoint = "none"; };
    "rpool_orm/state/actual" = { mountpoint = "/var/lib/private/actual"; };
    "rpool_orm/state/postgresql" = { mountpoint = "/var/lib/postgresql"; };
  };

  services.sanoid.datasets."rpool_orm/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/var/lib/postgresql/17";
    # managing imperatively instead of using ensureDatabases/ensureUsers

    enableTCPIP = true;
    settings = {
      port = 5432;
      # TODO: fix SSL
      # ssl = true;
    };
    # only allow remote connections from within Tailscale
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust   # used by nixos for local monitoring
      host  sameuser  all     100.64.0.0/10 scram-sha-256
      host  sameuser  all     fd7a:115c:a1e0::/48 scram-sha-256
    '';
  };
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5432 ];

  qenya.services.actual = {
    enable = true;
    domain = "actual.unspecified.systems";
  };
  fountain.services.web-redirect = {
    enable = true;
    domains = {
      "actual.qenya.tel" = "actual.unspecified.systems";
    };
  };

  system.stateVersion = "23.11";
}
