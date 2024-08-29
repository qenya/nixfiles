{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.qenya.sysadmin;
in
{
  options.qenya.sysadmin.enable = mkEnableOption "Base configuration for headless servers";

  config = mkIf cfg.enable {
    time.timeZone = "Etc/UTC";

    # Allow remote deployment with colmena
    deployment.targetUser = null;
    security.sudo.wheelNeedsPassword = false;
    nix.settings.trusted-users = [ "@wheel" ];
  };
}
