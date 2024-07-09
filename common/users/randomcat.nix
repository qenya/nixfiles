{ config, lib, pkgs, ... }:

let keys = import ../../keys.nix;
in
{
  users.users.randomcat = {
    isNormalUser = true;
    home = "/home/randomcat";
    openssh.authorizedKeys.keys = keys.users.randomcat;
    uid = 1003;
  };
}
