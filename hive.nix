let sources = import ./npins;
in {
  meta = {
    nixpkgs = sources.nixpkgs;
  };

  defaults = { pkgs, ... }: {
    imports = [ ./pinning.nix ];
    deployment.replaceUnknownProfiles = false;
  };

  tohru = { name, nodes, ... }: {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };

    imports = [ ./hosts/tohru/configuration.nix ];
  };

  yevaud = {
    deployment.targetHost = "yevaud.birdsong.network";
    imports = [ ./hosts/yevaud/configuration.nix ];
  };
}
