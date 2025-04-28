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

      nix-shell = ''nix-shell --command "zsh"'';
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignorePatterns = [ "rm *" "pkill *" ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "direnv" ];
      theme = ""; # defer to powerlevel10k
    };

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./.p10k.zsh}
    '';

    envExtra = ''
      DEFAULT_USER=qenya
    '';
  };
}
