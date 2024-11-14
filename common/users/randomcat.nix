{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  keys = import ../../keys.nix;
  cfg = config.fountain.users.randomcat;
in
{
  options.fountain.users.randomcat = {
    enable = mkEnableOption "user randomcat";
  };

  config = mkIf cfg.enable {
    users.users.randomcat = {
      uid = 1000;
      isNormalUser = true;
      group = "randomcat";
      openssh.authorizedKeys.keys = keys.users.randomcat;
    };

    users.groups.randomcat.gid = config.users.users.randomcat.uid;
  };
}