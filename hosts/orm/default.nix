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
  };

  services.sanoid.datasets."rpool_orm/state" = {
    useTemplate = [ "production" ];
    recursive = "zfs";
  };
  
  # TODO: modularise this
  randomcat.services.zfs.datasets."rpool_orm/state".zfsPermissions.users.backup = [ "hold" "send" ];
  users.users.backup = {
    group = "backup";
    isSystemUser = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFa3hjej6KGmS2aQ4s46Y7U8pN4yyR2FuMofpHRwXNk syncoid@elucredassa"
    ];
    packages = with pkgs; [ mbuffer lzop ]; # syncoid uses these if available but doesn't pull them in automatically
  };
  users.groups.backup = { };

  qenya.services.actual = {
    enable = true;
    domain = "actual.qenya.tel";
  };

  system.stateVersion = "23.11";
}
