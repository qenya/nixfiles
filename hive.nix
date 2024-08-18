let sources = import ./npins;
in {
  meta.nixpkgs = sources.nixpkgs;

  defaults = { name, nodes, config, lib, pkgs, ... }: {
    deployment.replaceUnknownProfiles = lib.mkDefault false;
    networking.hostName = name;

    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        agenix = (import sources.agenix { inherit pkgs; }).agenix;
        nur = (import sources.nur { inherit pkgs; });
        vscode-extensions = (import sources.nix-vscode-extensions).extensions.x86_64-linux; # TODO: This should check the host architecture
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    imports = [
      (import "${sources.home-manager}/nixos")
      (import "${sources.agenix}/modules/age.nix")
      (import "${sources.birdsong}/module.nix")
      ./pinning.nix
      ./common
      ./services
    ];
  };

  tohru = { name, nodes, ... }: {
    networking.hostId = "31da19c1";
    time.timeZone = "Europe/London";

    imports = [
      ./deployment/local.nix
      ./hosts/tohru/configuration.nix
    ];
  };

  yevaud = { name, nodes, ... }: {
    networking.hostId = "09673d65";
    time.timeZone = "Etc/UTC";

    imports = [
      ./deployment/remote.nix
      ./hosts/yevaud/configuration.nix
    ];
  };

  orm = { name, nodes, ... }: {
    networking.hostId = "00000000";
    time.timeZone = "Etc/UTC";

    imports = [
      ./deployment/remote.nix
      ./hosts/orm/configuration.nix
    ];
  };

  kalessin = { name, nodes, ... }: {
    networking.hostId = "534b538e";
    time.timeZone = "Etc/UTC";
    deployment = {
      buildOnTarget = true;
      replaceUnknownProfiles = true;
    };

    imports = [
      ./deployment/remote.nix
      ./hosts/kalessin/configuration.nix
    ];
  };
}
