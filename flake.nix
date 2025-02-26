{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?ref=master&dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Third-party flake providing package and NixOS module for Actual Budget as
    # nixpkgs are having trouble: https://github.com/NixOS/nixpkgs/issues/269069
    actual = {
      url = "git+https://git.xeno.science/xenofem/actual-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    birdsong.url = "git+https://git.qenya.tel/qenya/birdsong?ref=main";

    scoutshonour = {
      url = "git+https://git.qenya.tel/qenya/nix-scoutshonour?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-small, nixpkgs-unstable, flake-parts, colmena, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          packages = [
            inputs.colmena.packages.${system}.colmena
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
        "qenya".imports = [
          inputs.plasma-manager.homeManagerModules.plasma-manager
          ./home/qenya
        ];

        "qenya@shaw".imports = [ ./hosts/shaw/home.nix ];
      };

      flake.colmena = {
        meta = {
          nixpkgs = import nixpkgs-unstable {
            system = "x86_64-linux";
            overlays = [
              inputs.lix-module.overlays.default
            ];
          };
          nodeNixpkgs = {
            kilgharrah = import nixpkgs { system = "x86_64-linux"; };
            tohru = import nixpkgs { system = "x86_64-linux"; };
            elucredassa = import nixpkgs-small { system = "x86_64-linux"; };
            yevaud = import nixpkgs-small { system = "x86_64-linux"; };
            orm = import nixpkgs-small { system = "x86_64-linux"; };
            kalessin = import nixpkgs-small { system = "aarch64-linux"; };
          };
          specialArgs = {
            inherit self;
            inherit inputs;
          };
        };

        defaults = { config, lib, pkgs, ... }: {
          # disable remote deployment by default
          # (can stil build locally with nixos-rebuild)
          deployment.targetHost = lib.mkDefault null;
          deployment.buildOnTarget = lib.mkDefault true;

          imports = [
            inputs.lix-module.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.agenix.nixosModules.default
            inputs.birdsong.nixosModules.default
            inputs.actual.nixosModules.default
            ./common
            ./services
            (builtins.toPath "${inputs.randomcat}/services/default.nix")
          ];
        };

        elucredassa.deployment.targetHost = "10.127.3.2";
        yevaud.deployment.targetHost = "yevaud.birdsong.network";
        orm.deployment.targetHost = "orm.birdsong.network";
        kalessin.deployment.targetHost = "kalessin.birdsong.network";

        kilgharrah.imports = [ ./hosts/kilgharrah ];
        tohru.imports = [ ./hosts/tohru ];
        elucredassa.imports = [ ./hosts/elucredassa ];
        yevaud.imports = [ ./hosts/yevaud ];
        orm.imports = [ ./hosts/orm ];
        kalessin.imports = [ ./hosts/kalessin ];
      };
    };
}
