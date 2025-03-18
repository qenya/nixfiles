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
      charliermarsh.ruff
      dbaeumer.vscode-eslint
      eamodio.gitlens
      golang.go
      jdinhlife.gruvbox
      jnoortheen.nix-ide
      matangover.mypy
      mkhl.direnv
      ms-python.black-formatter
      ms-python.python
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
    ];
    mutableExtensionsDir = false;
    userSettings = {
      "css.format.spaceAroundSelectorSeparator" = true;
      "css.format.newlineBetweenSelectors" = false;
      "debug.allowBreakpointsEverywhere" = true;
      "extensions.autoUpdate" = false;
      "files.insertFinalNewline" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.inputValidation" = true;
      "git.inputValidationSubjectLength" = null;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings".nil = {
        diagnostics.ignored = [ "unused_binding" "unused_with" ];
        formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
        nix.flake.autoArchive = true;
      };
      "rust-analyzer.check.command" = "clippy";
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "workbench.colorTheme" = "Gruvbox Dark Medium";

      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "editor.formatOnSave" = false;
      };
      "go.alternateTools" = {
        "go" = "${pkgs.go}/bin/go";
        "golangci-lint" = "${pkgs.golangci-lint}/bin/golangci-lint";
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

      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
      };
      "ruff.nativeServer" = "on";
      "ruff.path" = "${pkgs.ruff}/bin/ruff";
      "mypy.dmypyExecutable" = "${pkgs.mypy}/bin/dmypy";
    };
  };
}
