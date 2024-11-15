{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.remote-builder;
in
{
  options.qenya.services.remote-builder = {
    enable = mkEnableOption "remote builder";
    authorizedKeys = {
      keys = mkOption {
        type = types.listOf types.singleLineStr;
        default = [ ];
        description = ''
          A list of verbatim OpenSSH public keys that should be authorized to
          use this remote builder. See
          `users.users.<name>.openssh.authorizedKeys.keys`.
        '';
      };
      keyFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          A list of files each containing one OpenSSH public key that should be
          authorized to use this remote builder. See
          `users.users.<name>.openssh.authorizedKeys.keyFiles`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.remotebuild = {
      isSystemUser = true;
      group = "nogroup";
      shell = "/bin/sh";
      openssh.authorizedKeys.keys = cfg.authorizedKeys.keys;
      openssh.authorizedKeys.keyFiles = cfg.authorizedKeys.keyFiles;
    };

    nix.nrBuildUsers = 64;
    nix.settings.trusted-users = [ "remotebuild" ];
  };
}
