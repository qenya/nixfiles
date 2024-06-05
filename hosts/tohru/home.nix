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
    packages = with pkgs; [
      # TODO: move these to home-manager
      bitwarden
      firefox
      tor-browser-bundle-bin
    ];
  };

  home-manager.users.qenya = { pkgs, ... }: {
    home.homeDirectory = config.users.users.qenya.home;

    home.packages = with pkgs; [
      fortune
      htop
      tree

      nil
      nixpkgs-fmt
    ];

    dconf = {
      enable = true;
      settings =
        let
          backgroundOptions = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "${config.users.users.qenya.home}/.background-image";
            primary-color = "#3a4ba0";
            secondary-color = "#2f302f";
          };
        in
        {
          "org/gnome/desktop/background" = backgroundOptions // {
            picture-uri-dark = backgroundOptions.picture-uri;
          };
          "org/gnome/desktop/screensaver" = backgroundOptions;
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
    };
    home.file.".background-image".source = ./background-image.jpg;

    programs.chromium.enable = true;

    programs.git = {
      enable = true;
      userName = "Katherina Walshe-Grey";
      userEmail = "git@katherina.rocks";
    };

    programs.vscode =
      let
        system = builtins.currentSystem;
        sources = import ../../npins;
        extensions = (import sources.nix-vscode-extensions).extensions.${system};
      in
      {
        enable = true;
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        package = pkgs.vscodium;
        extensions = (with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          ms-python.python
        ]) ++ (with extensions.open-vsx; [
          robbowen.synthwave-vscode
        ]);
        mutableExtensionsDir = false;
        userSettings = {
          "extensions.autoUpdate" = false;
          "git.autofetch" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings".nil = {
            diagnostics.ignored = [ "unused_binding" "unused_with" ];
            formatting.command = [ "nixpkgs-fmt" ];
          };
          "workbench.colorTheme" = "SynthWave '84";
        };
      };

    home.stateVersion = "23.11";
  };
}
