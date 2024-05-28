let sources = import ./npins;
in {
  meta = {
    nixpkgs = sources.nixpkgs;
  };

  defaults = { pkgs, ... }: {
    imports = [
      ./pinning.nix
      (import "${sources.home-manager}/nixos")
    ];
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
