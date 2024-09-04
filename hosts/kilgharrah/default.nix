{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostId = "72885bb5";

  deployment = {
    allowLocalDeployment = true;
    # temporarily allow remote deployment for bootstrapping
    targetHost = "192.168.2.1";
    targetUser = null;
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ "@wheel" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kilgharrah"; # Define your hostname.
  
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "gb";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  age.secrets.user-password-kilgharrah-qenya.file = ../../secrets/user-password-kilgharrah-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-kilgharrah-qenya.path;
  users.users.qenya.extraGroups = [
    "wheel"
    "networkmanager"
  ];
  home-manager.users.qenya = {
    programs.vscode.enable = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}