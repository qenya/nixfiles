{ config, lib, pkgs,... }:

{
  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [ "/share/zsh" ];
  };
}
