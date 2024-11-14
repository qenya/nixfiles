{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  keys = import ../../keys.nix;
  cfg = config.fountain.users.trungle;
in
{
  options.fountain.users.trungle = {
    enable = mkEnableOption "user trungle";
  };

  config = mkIf cfg.enable {
    users.users.trungle = {
      uid = 1002;
      isNormalUser = true;
      group = "trungle";
      openssh.authorizedKeys.keys = keys.users.trungle;
    };

    users.groups.trungle.gid = config.users.users.trungle.uid;
  };
}