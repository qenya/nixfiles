{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;

  age.secrets.wireguard-peer-tohru.file = ../../secrets/wireguard-peer-tohru.age;

  birdsong.peering = {
    enable = true;
    privateKeyFile = config.age.secrets.wireguard-peer-tohru.path;
    persistentKeepalive = 23;
  };

  programs.evolution.enable = true;
  qenya.services.fonts.enable = true;
  qenya.services.steam.enable = true;

  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      ./home.nix
    ];
  };

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "gb";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  age.secrets.user-password-tohru-qenya.file = ../../secrets/user-password-tohru-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-tohru-qenya.path;
  users.users.qenya.extraGroups = [
    "wheel" # sudo
    "networkmanager" # UI wifi configuration
    "dialout" # access to serial ports
  ];

  # USB drives
  boot.supportedFilesystems = [ "ntfs" ];

  hardware.enableAllFirmware = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  boot.initrd.luks.devices = {
    "rpool".device = "/dev/nvme0n1p2";
  };

  system.stateVersion = "23.11";
}

