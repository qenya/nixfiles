{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf mkDefault;
  isGraphical = osConfig.services.xserver.enable;
in
{
  programs.vscode = mkIf isGraphical {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      eamodio.gitlens
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
      "go.alternateTools" = {
        "go" = "${pkgs.go}/bin/go";
        "gopls" = "${pkgs.gopls}/bin/gopls";
        "dlv" = "${pkgs.delve}/bin/dlv";
        "staticcheck" = "${pkgs.go-tools}/bin/staticcheck";
      };
      "go.lintTool" = "golangci-lint";
      "go.toolsManagement.checkForUpdates" = "off";
      "gopls" = {
        "formatting.gofumpt" = true;
        "ui.semanticTokens" = true;
      };
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings".nil = {
        diagnostics.ignored = [ "unused_binding" "unused_with" ];
        formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
        nix.flake.autoArchive = true;
      };
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "workbench.colorTheme" = "Gruvbox Dark Medium";
    };
  };
}
