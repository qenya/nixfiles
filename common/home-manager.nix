{ config, lib, pkgs, ... }:

{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users = {
      qenya = { config, lib, pkgs, osConfig, ... }: {
        home.homeDirectory = osConfig.users.users.qenya.home;

        imports = [
          ../home/qenya
        ];
      };
    };
  };
}
