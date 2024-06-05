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

    imports = [
      (import "${sources.home-manager}/nixos")
      ./pinning.nix
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
