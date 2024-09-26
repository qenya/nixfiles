{ config, lib, pkgs, self, ... }:

let keys = import ../../keys.nix;
in {
  users.users.qenya = {
    isNormalUser = true;
    home = "/home/qenya";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = keys.users.qenya;
    uid = 1001;
  };

  programs.zsh.enable = true;

  home-manager.users."qenya" = self.homeManagerModules."qenya";
}
