{ config, lib, pkgs, ... }:

{
  users.users.qenya = {
    isNormalUser = true;
    home = "/home/qenya";
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # UI wifi configuration
      "dialout" # access to serial ports
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEmkV9arotms79lJPsLHkdzAac4eu3pYS08ym0sB/on qenya@tohru"
    ];
    uid = 1001;
  };

  home-manager.users.qenya = { config, lib, pkgs, osConfig, ... }: {
    home.homeDirectory = osConfig.users.users.qenya.home;

    programs.git = {
      enable = true;
      userName = "Katherina Walshe-Grey";
      userEmail = "git@qenya.tel";
    };

    home.stateVersion = "23.11";
  };
}
