{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf mkDefault;
  isGraphical = osConfig.services.xserver.enable;
in
{
  programs.vscode = mkIf isGraphical {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        redhat.ansible
        ms-python.black-formatter
        ms-azuretools.vscode-docker
        mkhl.direnv
        dbaeumer.vscode-eslint
        golang.go
        eamodio.gitlens
        jdinhlife.gruvbox
        vadimcn.vscode-lldb
        matangover.mypy
        jnoortheen.nix-ide
        ms-python.python
        shopify.ruby-lsp
        charliermarsh.ruff
        rust-lang.rust-analyzer
        redhat.vscode-yaml
      ];
      userSettings = {
        "ansible.ansible.path" = "${pkgs.ansible}/bin/ansible";
        "ansible.validation.lint.enabled" = true;
        "ansible.validation.lint.path" = "${pkgs.ansible-lint}/bin/ansible-lint";
        "ansible.ansibleNavigator.path" = "${pkgs.ansible-navigator}/bin/ansible-navigator";
        "ansible.python.interpreterPath" = "${pkgs.python3}/bin/python";
        "ansible.lightspeed.enabled" = false;
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
        "redhat.telemetry.enabled" = false;
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
        "python.createEnvironment.contentButton" = "show";
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";
        "ruff.nativeServer" = "on";
        "ruff.path" = [ "${pkgs.ruff}/bin/ruff" ];
        "mypy.dmypyExecutable" = "${pkgs.mypy}/bin/dmypy";

        "[ruby]" = {
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;
        };
      };
    };
  };
}
