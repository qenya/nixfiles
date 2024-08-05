{ name, nodes, config, lib, pkgs, ... }:

{
  deployment = {
    allowLocalDeployment = true;
    targetHost = null;
    tags = [ "local" ];
  };
}
