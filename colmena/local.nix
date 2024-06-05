{ name, nodes, config, lib, pkgs, ... }:

{
  deployment = {
    allowLocalDeployment = true;
    targetHost = null;
    tags = [ "local" ];
  };

  environment.systemPackages = with pkgs; [
    colmena
    npins
  ];
}
