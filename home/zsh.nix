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
