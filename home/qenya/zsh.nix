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

    envExtra = ''
      DEFAULT_USER=qenya
    '';
  };
}
