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
    # FIXME: failing drive
    # ./ftp.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "kilgharrah";
  networking.hostId = "72885bb5";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  qenya.base-graphical.enable = true;
  qenya.base-graphical.desktop = "plasma6";

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  qenya.services.pipewire.lowLatency.enable = true;

  fountain.users.qenya.enable = true;
  age.secrets.user-password-kilgharrah-qenya.file = ../../secrets/user-password-kilgharrah-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-kilgharrah-qenya.path;
  users.users.qenya.extraGroups = [ "wheel" ];
  home-manager.users.qenya = { pkgs, ... }: {
    home.packages = with pkgs; [ obs-studio ];
    # For the moment, this hosts some network-accessible services, so we want it on 24/7
    programs.plasma.powerdevil.AC.autoSuspend.action = "nothing";
  };

  qenya.services.remote-builder = {
    enable = true;
    authorizedKeys.keys = [
      keys.machines.yevaud
      keys.machines.orm
      keys.machines.tohru
    ];
  };

  # programs.steam.enable = true;
  # qenya.services.audiobookshelf = {
  #   enable = true;
  #   domain = "audiobookshelf.qenya.tel";
  # };
  # qenya.services.jellyfin = {
  #   enable = true;
  #   domain = "jellyfin.qenya.tel";
  # };
  # qenya.services.navidrome = {
  #   enable = true;
  #   domain = "music.qenya.tel";
  #   dataDir = "/srv/music";
  # };

  system.stateVersion = "24.05";

}
