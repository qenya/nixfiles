{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ll = "ls -l";
      nix-shell = ''nix-shell --command "zsh"''; # TODO: tweak theme to display something when inside nix-shell
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignorePatterns = [ "rm *" "pkill *" ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "agnoster";
    };

    initExtra = ''
      # If a shell is started in a directory with a shell.nix, automatically run nix-shell
      if [ -f ./shell.nix ]; then
        if [ -z "$IN_NIX_SHELL" ]; then
          nix-shell --command "zsh"
        fi
      fi
    '';

    envExtra = ''
      DEFAULT_USER=qenya
    '';
  };
}
