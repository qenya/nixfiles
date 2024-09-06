{ config, lib, pkgs, ... }:

{
  home-manager.users = {
    qenya = { config, lib, pkgs, osConfig, ... }: {
      home.homeDirectory = osConfig.users.users.qenya.home;

      imports = [
        ../home/qenya
      ];
    };
  };
}
