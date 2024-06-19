{ name, nodes, config, lib, pkgs, ... }:

let sources = import ../npins;
in {
  deployment = {
    allowLocalDeployment = true;
    targetHost = null;
    tags = [ "local" ];
  };

  environment.systemPackages = with pkgs; [
    agenix
    colmena
    npins
  ];
}
