let sources = import ./npins;
in {
  meta.nixpkgs = sources.nixpkgs;

  defaults = { name, pkgs, ... }: {
    deployment.replaceUnknownProfiles = false;
    networking.hostName = name;

    environment.systemPackages = with pkgs; [
      git
      wget
    ];

    # Make <nixpkgs> point systemwide to the pinned nixpkgs above
    # https://jade.fyi/blog/pinning-nixos-with-npins/
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.flake.source = sources.nixpkgs;
    nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

    imports = [
      (import "${sources.home-manager}/nixos")
      ./users/qenya.nix
    ];
  };

  tohru = {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;
    };

    networking.hostId = "31da19c1";
    time.timeZone = "Europe/London";

    imports = [ ./hosts/tohru/configuration.nix ];
  };

  yevaud = { name, ... }: {
    deployment.targetHost = "${name}.birdsong.network";

    networking.hostId = "09673d65";
    time.timeZone = "Etc/UTC";

    imports = [ ./hosts/yevaud/configuration.nix ];
  };
}
