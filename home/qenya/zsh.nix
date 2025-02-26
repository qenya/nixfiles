{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ direnv ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ll = "ls -l";

      # don't clobber
      mv = "mv -i";
      rename = "rename -i";

      nix-shell = ''nix-shell --command "zsh"''; # TODO: tweak theme to display something when inside nix-shell
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignorePatterns = [ "rm *" "pkill *" ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "direnv" ];
      theme = "agnoster";
    };

    envExtra = ''
      DEFAULT_USER=qenya
    '';
  };
}
