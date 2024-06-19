{ name, nodes, config, lib, pkgs, ... }:

{
  deployment = {
    targetHost = "${name}.birdsong.network";
    targetUser = "qenya";
    tags = [ "remote" ];
  };

  # Required for remote builds
  security.sudo.wheelNeedsPassword = false;

  imports = [
    ../common/openssh.nix
  ];
}
