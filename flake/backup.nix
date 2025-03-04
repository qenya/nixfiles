{ config, lib, pkgs, ... }:
let
  cfg = config.fountain.backup;
  keys = import ../keys.nix;

  syncOptions = {
    dataset = lib.mkOption {
      type = lib.types.str;
      description = ''
        The name of the dataset to be synced (not including its parent
        datasets, if any). This will be the same on the source and target.
        It must already exist on the source, defined with the
        {option}`randomcat.services.zfs` module, and not exist on the target.
      '';
    };
    sourceHost = lib.mkOption {
      type = lib.types.str;
      description = ''
        The host from which the dataset should be synced. Must be an entry in
        {option}`flake.colmena`.
      '';
    };
    targetHost = lib.mkOption {
      type = lib.types.str;
      description = ''
        The host to which the dataset should be synced. Must be an entry in
        {option}`flake.colmena`.
      '';
    };
    source = lib.mkOption {
      type = lib.types.str;
      description = ''
        The path to the synced dataset in the ZFS namespace on the source host,
        excluding the component that is the name of the dataset itself.
      '';
    };
    target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The path to the synced dataset in the ZFS namespace on the target host,
        excluding the component that is the name of the dataset itself. It must
        already exist, defined with the {option}`randomcat.services.zfs`
        module.
      '';
    };
  };
in
{
  options.fountain.backup = {
    keys = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.singleLineStr);
      default = { };
      description = ''
        Lists of verbatim OpenSSH public keys that may be used to identify the
        syncoid user on each target host. The key to each list must be the
        host's hostname, as listed in {option}`flake.colmena`.
      '';
      example = {
        host = [ "ssh-rsa AAAAB3NzaC1yc2etc/etc/etcjwrsh8e596z6J0l7 example@host" ];
        bar = [ "ssh-ed25519 AAAAC3NzaCetcetera/etceteraJZMfk3QPfQ foo@bar" ];
      };
    };

    sync = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule { options = syncOptions; });
      default = { };
      description = ''
        Details of ZFS datasets whose snapshots should be synced from machine
        to machine using syncoid. Syncoid will run hourly at 15 past the hour
        and copy all ZFS snapshots from the source dataset to the target
        dataset (recursing into child datasets).
        
        See descriptions for the individual options for more details. The name
        of each attribute in this set is arbitrary and used to generate systemd
        unit names.

        This module does not actually cause snapshots to be taken; sanoid must
        be configured separately to do this.
      '';
      example = {
        "orm-state" = {
          dataset = "state";
          sourceHost = "orm";
          targetHost = "elucredassa";
          source = "rpool_orm";
          target = "rpool_elucredassa/backup/orm";
        };
      };
    };
  };

  # TODO: add some assertions to verify the options

  config.flake.colmena = lib.mkMerge (lib.mapAttrsToList
    (name: sync:
      let
        inherit (sync) dataset sourceHost targetHost source target;
        # TODO: don't want to have to dig into the node config for the fqdn
        sourceFqdn = config.flake.nixosConfigurations.${sourceHost}.config.networking.fqdn;
      in
      {
        ${sourceHost} = { pkgs, ... }: {
          randomcat.services.zfs.datasets."${source}/${dataset}".zfsPermissions.users.backup = [ "hold" "send" ];

          users.users.backup = {
            group = "backup";
            isSystemUser = true;
            useDefaultShell = true;
            openssh.authorizedKeys.keys = cfg.keys.${targetHost};
            packages = with pkgs; [ mbuffer lzop ]; # syncoid uses these if available but doesn't pull them in automatically
          };
          users.groups.backup = { };
        };

        ${targetHost} = {
          randomcat.services.zfs.datasets.${target}.zfsPermissions.users.syncoid = [ "mount" "create" "receive" "recordsize" ];

          services.syncoid = {
            enable = true;
            interval = "*-*-* *:15:00";
            commonArgs = [ "--no-sync-snap" ];
            commands = {
              ${name} = {
                source = "backup@${sourceFqdn}:${source}/${dataset}";
                target = "${target}/${dataset}";
                recursive = true;
                recvOptions = "ux recordsize o compression=lz4";
              };
            };
          };

          # TODO: this should be handled by a networking module
          programs.ssh.knownHosts.${sourceFqdn}.publicKey = keys.machines.${sourceHost};
        };
      })
    cfg.sync
  );
}
