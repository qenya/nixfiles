{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types genAttrs;
  cfg = config.fountain;
in
{
  # TODO: consider DRY-ing these
  imports = [
    ./gaelan.nix
    ./qenya.nix
    ./randomcat.nix
    ./trungle.nix
  ];

  options.fountain = {
    admins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users who should have root on this system";
    };
  };

  config = {
    users.mutableUsers = false;

    users.users = genAttrs cfg.admins
      (name: {
        extraGroups = [ "wheel" ];
      });
  };
}
