{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix?tag=0.15.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };

    birdsong.url = "git+https://git.qenya.tel/qenya/birdsong?ref=main";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, birdsong, ... }: {
    colmena = {
      meta.nixpkgs = import nixpkgs { system = "x86_64-linux"; };
      meta.nodeNixpkgs.kalessin = import nixpkgs { system = "aarch64-linux"; }; # TODO: this should be generated from the host config somehow

      defaults = { name, nodes, config, lib, pkgs, ... }: {
        deployment.replaceUnknownProfiles = lib.mkDefault false;
        networking.hostName = name;

        nix.settings.experimental-features = "nix-command flakes";
        nixpkgs.flake.source = nixpkgs;
        nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

        nixpkgs.config = {
          allowUnfree = true;
          packageOverrides = pkgs:
            let
              sources = import ./npins;
              inherit (config.nixpkgs.hostPlatform) system;
            in
            {
              agenix = agenix.packages.${system}.default;
              nur = (import sources.nur {
                nurpkgs = pkgs;
                inherit pkgs;
              });
            };
        };

        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
        };

        imports = [
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          birdsong.nixosModules.default
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
    };
  };
}
