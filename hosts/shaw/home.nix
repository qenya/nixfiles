{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--gui-address=:8385"
      "--home=/home/qenya/state/syncthing"
    ];
  };
}
