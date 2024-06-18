{ name, nodes, config, lib, pkgs, ... }:

let sources = import ../npins;
in {
  deployment = {
    allowLocalDeployment = true;
    targetHost = null;
    tags = [ "local" ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    agenix = (import "${sources.agenix}" { inherit pkgs; }).agenix;
  };

  environment.systemPackages = with pkgs; [
    agenix
    colmena
    npins
  ];
}
