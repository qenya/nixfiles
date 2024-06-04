{ config, lib, pkgs, ... }:

{
  users.users.bluebird = {
    isNormalUser = true;
    description = "Bluebird";
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

  home-manager.users.bluebird = { pkgs, ... }: {
    home.packages = with pkgs; [
      fortune
      htop
      tree

      nil
      nixpkgs-fmt
    ];

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

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
