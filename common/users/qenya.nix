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
}
