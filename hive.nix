let sources = import ./npins;
in {
  meta.nixpkgs = sources.nixpkgs;

  defaults = { name, nodes, ... }: {
    deployment.replaceUnknownProfiles = false;
    networking.hostName = name;

    nixpkgs.config.allowUnfree = true;

    imports = [
      (import "${sources.home-manager}/nixos")
      ./pinning.nix
      ./common/utilities.nix
      ./users/qenya.nix
    ];
  };

  tohru = { name, nodes, ... }: {
    networking.hostId = "31da19c1";
    time.timeZone = "Europe/London";

    imports = [
      ./colmena/local.nix
      ./hosts/tohru/configuration.nix
    ];
  };

  yevaud = { name, nodes, ... }: {
    networking.hostId = "09673d65";
    time.timeZone = "Etc/UTC";
    
    imports = [
      ./colmena/remote.nix
      ./hosts/yevaud/configuration.nix
    ];
  };
}
