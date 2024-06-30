{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
