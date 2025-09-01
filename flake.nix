{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.stable.follows = "";
      inputs.nix-github-actions.follows = "";
      inputs.flake-compat.follows = "";
    };

    randomcat = {
      url = "github:randomnetcat/nix-configs";
      flake = false;
    };

    scoutshonour = {
      url = "git+https://git.qenya.tel/qenya/nix-scoutshonour?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-small, nixpkgs-unstable, flake-parts, colmena, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./flake ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.colmena
            inputs.agenix.packages.${system}.default
            inputs.plasma-manager.packages.${system}.rc2nix
          ];
        };
      };

      flake.nixosConfigurations = self.outputs.colmenaHive.nodes;
      flake.colmenaHive = colmena.lib.makeHive self.outputs.colmena;

      # The name of this output type is not standardised. I have picked
      # "homeManagerModules" as the discussion here suggests it's the most common:
      # https://github.com/nix-community/home-manager/issues/1783
      #
      # However, note CppNix >= 2.22.3, >= 2.24 has blessed "homeModules":
      # https://github.com/NixOS/nix/pull/10858
      flake.homeManagerModules = {
        "qenya".imports = [ ./home/qenya ];
        "qenya@shaw".imports = [ ./hosts/shaw/home.nix ];
      };

      fountain.backup = {
        keys = {
          elucredassa = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFa3hjej6KGmS2aQ4s46Y7U8pN4yyR2FuMofpHRwXNk syncoid@elucredassa" ];
        };
        sync = {
          "orm-state" = {
            dataset = "state";
            sourceHost = "orm";
            targetHost = "elucredassa";
            source = "rpool_orm";
            target = "rpool_elucredassa/backup/orm";
          };
          "kalessin-state" = {
            dataset = "state";
            sourceHost = "kalessin";
            targetHost = "elucredassa";
            source = "rpool_kalessin";
            target = "rpool_elucredassa/backup/kalessin";
          };
        };
      };

      flake.colmena =
        let
          home-manager = inputs.home-manager.nixosModules.home-manager;
          home-manager-unstable = inputs.home-manager-unstable.nixosModules.home-manager;
        in
        {
          meta = {
            nixpkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
            nodeNixpkgs = {
              kilgharrah = import nixpkgs-unstable { system = "x86_64-linux"; };
              tohru = import nixpkgs { system = "x86_64-linux"; };
              elucredassa = import nixpkgs-small { system = "x86_64-linux"; };
              yevaud = import nixpkgs-small { system = "x86_64-linux"; };
              orm = import nixpkgs-small { system = "x86_64-linux"; };
              kalessin = import nixpkgs-small { system = "aarch64-linux"; };
              tehanu = import nixpkgs-small { system = "aarch64-linux"; };
            };
            specialArgs = {
              inherit self;
              inherit inputs;
            };
          };

          defaults = { config, lib, pkgs, ... }: {
            deployment.targetHost = lib.mkDefault config.networking.fqdn;
            deployment.buildOnTarget = lib.mkDefault true;

            imports = [
              inputs.agenix.nixosModules.default
              ./common
              ./services
              (builtins.toPath "${inputs.randomcat}/services/default.nix")
            ];
          };

          kilgharrah.deployment.targetHost = null; # disable remote deployment
          tohru.deployment.targetHost = null; # disable remote deployment
          elucredassa.deployment.targetHost = "100.73.34.182"; # TODO: no fqdn yet

          kilgharrah.imports = [ ./hosts/kilgharrah home-manager-unstable ];
          tohru.imports = [ ./hosts/tohru home-manager ];
          elucredassa.imports = [ ./hosts/elucredassa home-manager ];
          yevaud.imports = [ ./hosts/yevaud home-manager ];
          orm.imports = [ ./hosts/orm home-manager ];
          kalessin.imports = [ ./hosts/kalessin home-manager ];
          tehanu.imports = [ ./hosts/tehanu home-manager ];
        };
    };
}
