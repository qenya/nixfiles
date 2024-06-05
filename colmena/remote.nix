{ name, nodes, config, lib, pkgs, ... }:

{
  deployment = {
    targetHost = "${name}.birdsong.network";
    tags = [ "remote" ];
  };

  imports = [
    ../services/openssh.nix
  ];
}
