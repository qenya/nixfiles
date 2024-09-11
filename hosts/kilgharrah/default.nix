{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostId = "72885bb5";

  deployment = {
    allowLocalDeployment = true;
    targetHost = null; # disallow remote deployment
  };

  qenya.base-graphical.enable = true;
  qenya.base-graphical.desktop = "plasma6";

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  services.xserver.xkb.layout = "gb";

  age.secrets.user-password-kilgharrah-qenya.file = ../../secrets/user-password-kilgharrah-qenya.age;
  users.users.qenya.hashedPasswordFile = config.age.secrets.user-password-kilgharrah-qenya.path;
  users.users.qenya.extraGroups = [ "wheel" ];
  home-manager.users.qenya = {
    programs.firefox.enable = true;
    programs.vscode.enable = true;

    home.packages = with pkgs; [
      bitwarden
      discord
      tor-browser-bundle-bin
      zoom-us
    ];
  };

  programs.steam.enable = true;

  system.stateVersion = "24.05";

}
