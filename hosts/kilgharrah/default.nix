{ config, lib, pkgs, ... }:

{
  imports = [
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
    ./ftp.nix
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

  age.secrets.user-password-kilgharrah-qenya.file = ../../secrets/user-password-kilgharrah-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-kilgharrah-qenya.path;
  users.users.qenya.extraGroups = [ "wheel" ];
  home-manager.users.qenya = {
    # For the moment, this hosts some network-accessible services, so we want it on 24/7
    programs.plasma.powerdevil.AC.autoSuspend.action = "nothing";
  };

  programs.steam.enable = true;
  qenya.services.jellyfin = {
    enable = true;
    domain = "jellyfin.qenya.tel";
  };
  qenya.services.navidrome = {
    enable = true;
    domain = "music.qenya.tel";
    dataDir = "/srv/music";
  };

  system.stateVersion = "24.05";

}
