{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.email = "git@qenya.tel";
      user.name = "qenya";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
