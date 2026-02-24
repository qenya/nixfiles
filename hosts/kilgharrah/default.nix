{ config, lib, pkgs, ... }:

let
  keys = import ../../keys.nix;
in
{
  imports = [
    ./backup.nix
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
    ./plasma.nix

    ./ftp.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "kilgharrah";
  networking.hostId = "72885bb5";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  qenya.base-graphical.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  fountain.users.qenya.enable = true;
  age.secrets.user-password-kilgharrah-qenya.file = ../../secrets/user-password-kilgharrah-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-kilgharrah-qenya.path;
  fountain.admins = [ "qenya" ];
  home-manager.users.qenya = { pkgs, ... }: {
    home.packages = with pkgs; [
      heroic
      obs-studio
    ];
  };

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [
      keys.machines.yevaud
      keys.machines.orm
      keys.machines.tohru
      keys.machines.elucredassa
    ];
  };

  programs.steam.enable = true;
  qenya.services.audiobookshelf = {
    enable = true;
    domain = "audiobookshelf.qenya.tel";
  };
  qenya.services.jellyfin = {
    enable = true;
    domain = "tv.qenya.tel";
  };
  qenya.services.navidrome = {
    enable = false; # awaiting https://github.com/NixOS/nixpkgs/pull/493362
    domain = "music.qenya.tel";
    dataDir = "/srv/music";
  };
  fountain.services.web-redirect = {
    enable = true;
    domains = {
      "jellyfin.qenya.tel" = "tv.qenya.tel";
    };
  };

  system.stateVersion = "24.05";

}
