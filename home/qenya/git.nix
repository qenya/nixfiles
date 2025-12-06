{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.email = "git@qenya.tel";
      user.name = "Katherina Walshe-Grey";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
