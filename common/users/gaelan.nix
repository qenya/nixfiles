{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  keys = import ../../keys.nix;
  cfg = config.fountain.users.gaelan;
in
{
  options.fountain.users.gaelan = {
    enable = mkEnableOption "user gaelan";
  };

  config = mkIf cfg.enable {
    users.users.gaelan = {
      uid = 1003;
      isNormalUser = true;
      group = "gaelan";
      openssh.authorizedKeys.keys = keys.users.gaelan;
    };

    users.groups.gaelan.gid = config.users.users.gaelan.uid;
  };
}