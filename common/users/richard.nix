{ config, lib, pkgs, ... }:

let keys = import ../../keys.nix;
in
{
  users.users.richard = {
    isNormalUser = true;
    home = "/home/richard";
    openssh.authorizedKeys.keys = keys.users.richard;
    uid = 1002;
  };
}
