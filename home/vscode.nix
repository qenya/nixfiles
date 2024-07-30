{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      open-vsx.golang.go
      open-vsx.jnoortheen.nix-ide
      open-vsx.ms-python.python
      open-vsx.robbowen.synthwave-vscode
    ];
    mutableExtensionsDir = false;
    userSettings = {
      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "editor.formatOnSave" = false;
      };
      "extensions.autoUpdate" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.inputValidation" = true;
      "git.inputValidationSubjectLength" = null;
      "gopls" = {
        "formatting.gofumpt" = true;
        "ui.semanticTokens" = true;
      };
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings".nil = {
        diagnostics.ignored = [ "unused_binding" "unused_with" ];
        formatting.command = [ "nixpkgs-fmt" ];
      };
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "workbench.colorTheme" = "SynthWave '84";
    };
  };

  # Language servers etc
  home.packages = with pkgs; [
    gopls
    nil
    nixpkgs-fmt
  ];
}
