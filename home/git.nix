{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Katherina Walshe-Grey";
    userEmail = "git@qenya.tel";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
