{ config, lib, pkgs, ... }:

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

  home-manager.users.qenya = { config, lib, pkgs, osConfig, ... }: {
    home.homeDirectory = osConfig.users.users.qenya.home;
    imports = [ ../../home/qenya ];
  };
}
