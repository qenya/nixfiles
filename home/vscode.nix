{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs) fetchFromGitHub;
  system = "x86_64-linux"; # TODO: This should check the host architecture
  extensions =
    (import (fetchFromGitHub {
      # On a stable channel, do NOT keep this up-to-date! VS Code extensions
      # have breaking changes more frequently than the NixOS release cadence.
      owner = "nix-community";
      repo = "nix-vscode-extensions";
      rev = "27ce569a199d2da1a8483fe3d69dd41664da3a63";
      hash = "sha256-yyB4Kh3EFbYP+1JHza/IEeHwABypcYVi6vvWTmad/rY=";
    })).extensions.${system};
in {
  programs.vscode = {
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    extensions = with extensions.open-vsx; [
      golang.go
      jdinhlife.gruvbox
      jnoortheen.nix-ide
      ms-python.python
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
      "workbench.colorTheme" = "Gruvbox Dark Hard";
    };
  };

  # Language servers etc
  home.packages = mkIf config.programs.vscode.enable (with pkgs; [
    gopls
    nil
    nixpkgs-fmt
  ]);
}
