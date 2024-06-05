let sources = import ./npins;
in {
  meta.nixpkgs = sources.nixpkgs;

  defaults = { pkgs, ... }: {
    imports = [
      (import "${sources.home-manager}/nixos")
    ];
    deployment.replaceUnknownProfiles = false;
    
    # Make <nixpkgs> point systemwide to the pinned nixpkgs above
    # https://jade.fyi/blog/pinning-nixos-with-npins/
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.flake.source = sources.nixpkgs;
    nix.nixPath = ["nixpkgs=flake:nixpkgs"];
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
