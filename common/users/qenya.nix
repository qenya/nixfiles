{ config, lib, pkgs, self, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  keys = import ../../keys.nix;
  cfg = config.fountain.users.qenya;
in
{
  options.fountain.users.qenya = {
    enable = mkEnableOption "user qenya";
  };

  config = mkIf cfg.enable {
    users.users.qenya = {
      uid = 1001;
      isNormalUser = true;
      group = "qenya";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys.users.qenya;
    };

    users.groups.qenya.gid = config.users.users.qenya.uid;

    programs.zsh.enable = true;

    home-manager.users."qenya" = self.homeManagerModules."qenya";
  };
}
