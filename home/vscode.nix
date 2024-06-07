{ config, lib, pkgs, ... }:

{
  programs.vscode =
    let
      system = builtins.currentSystem;
      sources = import ../npins;
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
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings".nil = {
          diagnostics.ignored = [ "unused_binding" "unused_with" ];
          formatting.command = [ "nixpkgs-fmt" ];
        };
        "workbench.colorTheme" = "SynthWave '84";
      };
    };

  # Language servers etc
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
