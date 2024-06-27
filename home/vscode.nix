{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      open-vsx.jnoortheen.nix-ide
      open-vsx.ms-python.python
      open-vsx.robbowen.synthwave-vscode
    ];
    mutableExtensionsDir = false;
    userSettings = {
      "extensions.autoUpdate" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.inputValidation" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings".nil = {
        diagnostics.ignored = [ "unused_binding" "unused_with" ];
        formatting.command = [ "nixpkgs-fmt" ];
      };
      "terminal.integrated.allowChords" = false;
      "workbench.colorTheme" = "SynthWave '84";
    };
  };

  # Language servers etc
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
