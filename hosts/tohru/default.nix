{ config, lib, pkgs, ... }:

{
  imports = [
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix

    ./syncthing.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "tohru";
  networking.hostId = "31da19c1";

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  qenya.base-graphical.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  fountain.users.qenya.enable = true;
  age.secrets.user-password-tohru-qenya.file = ../../secrets/user-password-tohru-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-tohru-qenya.path;
  users.users.qenya.extraGroups = [
    "wheel" # sudo
    "networkmanager" # UI wifi configuration
    "dialout" # access to serial ports
  ];
  home-manager.users.qenya = { pkgs, ... }: {
    home.packages = with pkgs; [
      keepassxc
      amberol
      foliate
      nicotine-plus

      # games
      openttd
      prismlauncher
      nur.repos.qenya.digital-a-love-story
      nur.repos.qenya.dont-take-it-personally-babe
    ];
  };

  qenya.services.distributed-builds = {
    enable = true;
    keyFile = "/etc/ssh/ssh_host_ed25519_key";
    builders = [ "kalessin" ];
  };

  programs.evolution.enable = true; # not in home-manager yet; not declaratively configurable yet
  programs.steam.enable = true;

  system.stateVersion = "23.11";
}
