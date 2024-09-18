{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix

    ./syncthing.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostId = "31da19c1";

  qenya.base-graphical.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  age.secrets.user-password-tohru-qenya.file = ../../secrets/user-password-tohru-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-tohru-qenya.path;
  users.users.qenya.extraGroups = [
    "wheel" # sudo
    "networkmanager" # UI wifi configuration
    "dialout" # access to serial ports
  ];
  home-manager.users.qenya.imports = [ ./home.nix ];

  programs.evolution.enable = true; # not in home-manager yet; not declaratively configurable yet
  programs.steam.enable = true;

  system.stateVersion = "23.11";
}
