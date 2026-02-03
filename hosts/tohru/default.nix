{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkForce;
in
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

  # tohru does not have the resources to run this under other load and is generally powered off when not in use.
  # instead, just run `nix-store --optimise` every so often.
  nix.optimise.automatic = mkForce false;

  fountain.users.qenya.enable = true;
  fountain.admins = [ "qenya" ];
  age.secrets.user-password-tohru-qenya.file = ../../secrets/user-password-tohru-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-tohru-qenya.path;
  users.users.qenya.extraGroups = [
    "networkmanager" # UI wifi configuration
    "dialout" # access to serial ports
    "docker"
  ];

  nixpkgs.overlays = [ inputs.scoutshonour.overlays.default ];
  home-manager.users.qenya = { pkgs, ... }: {
    home.packages = with pkgs; [
      foliate
      nicotine-plus

      apostrophe
      blanket
      gnome-podcasts
      resources
      tuba
      wike
      wordbook

      # games
      openttd
      prismlauncher
      scoutshonour.digital-a-love-story
      scoutshonour.dont-take-it-personally-babe
    ];

    services.podman.enable = true;
  };

  qenya.services.distributed-builds = {
    enable = true;
    keyFile = "/etc/ssh/ssh_host_ed25519_key";
    builders = [ "kilgharrah" ];
  };

  programs.evolution.enable = true; # not in home-manager yet; not declaratively configurable yet
  programs.steam.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
