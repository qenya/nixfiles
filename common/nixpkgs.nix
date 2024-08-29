{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        agenix = inputs.agenix.packages.${config.nixpkgs.hostPlatform.system}.default;
      };
    };

    overlays = [ inputs.nur.overlay ];
  };
}
