{ name, nodes, config, lib, pkgs, ... }:

{
  deployment = {
    targetHost = "${name}.birdsong.network";
    targetUser = "qenya";
    tags = [ "remote" ];
  };

  security.sudo.wheelNeedsPassword = false;
}
