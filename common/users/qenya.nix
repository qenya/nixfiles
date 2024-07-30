{ config, lib, pkgs, ... }:

let keys = import ../../keys.nix;
in {
  users.users.qenya = {
    isNormalUser = true;
    home = "/home/qenya";
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # UI wifi configuration
      "dialout" # access to serial ports
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = keys.users.qenya;
    uid = 1001;
  };

  home-manager.users.qenya = { config, lib, pkgs, osConfig, ... }: {
    home.homeDirectory = osConfig.users.users.qenya.home;

    imports = [
      ../../home
    ];
  };
}
