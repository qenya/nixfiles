{ config, lib, pkgs, ... }:

let
  inherit (builtins) elem;
  inherit (lib) mkIf mkEnableOption mkOption types optional;
  cfg = config.qenya.services.distributed-builds;
in
{
  options.qenya.services.distributed-builds = {
    enable = mkEnableOption "distributed builds";
    keyFile = mkOption {
      type = types.path;
      description = ''
        Path to the OpenSSH private key to be used for distributed builds.
      '';
    };
    builders = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of builders to attempt to use for distributed builds.
      '';
      example = [ "kalessin" ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg ? keyFile;
      message = "must specify a private key to be used for distributed builds";
    }];

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines =
      (optional (elem "kalessin" cfg.builders) {
        hostName = "100.108.149.33"; # TODO: get tailscale internal DNS up
        sshUser = "remotebuild";
        sshKey = cfg.keyFile;
        systems = [ "aarch64-linux" ];
        maxJobs = 2;
        supportedFeatures = [ "big-parallel" ];
      })
      ++ (optional (elem "kilgharrah" cfg.builders) {
        hostName = "100.92.127.92"; # TODO: get tailscale internal DNS up
        sshUser = "remotebuild";
        sshKey = cfg.keyFile;
        systems = [ "x86_64-linux" ];
        maxJobs = 12;
        supportedFeatures = [ "big-parallel" ];
      });
  };
}
