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

    # TODO: remove dependency on NUR (#16)
    nur.url = "github:nix-community/NUR";

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

    # Third-party flake providing package and NixOS module for Actual Budget as
    # nixpkgs are having trouble: https://github.com/NixOS/nixpkgs/issues/269069
    actual = {
      url = "git+https://git.xeno.science/xenofem/actual-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    birdsong.url = "git+https://git.qenya.tel/qenya/birdsong?ref=compat-24.11";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-small, lix-module, home-manager, plasma-manager, nur, agenix, colmena, randomcat, actual, birdsong, ... }: {
    nixosConfigurations = (colmena.lib.makeHive self.outputs.colmena).nodes;

    # The name of this output type is not standardised. I have picked
    # "homeManagerModules" as the discussion here suggests it's the most common:
    # https://github.com/nix-community/home-manager/issues/1783
    #
    # However, note CppNix >= 2.22.3, >= 2.24 has blessed "homeModules":
    # https://github.com/NixOS/nix/pull/10858
    homeManagerModules = {
      "qenya".imports = [
        plasma-manager.homeManagerModules.plasma-manager
        ./home/qenya
      ];

      "qenya@shaw".imports = [ ./hosts/shaw/home.nix ];
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = {
          kilgharrah = import nixpkgs { system = "x86_64-linux"; };
          tohru = import nixpkgs { system = "x86_64-linux"; };
          yevaud = import nixpkgs-small { system = "x86_64-linux"; };
          orm = import nixpkgs-small { system = "x86_64-linux"; };
          kalessin = import nixpkgs-small { system = "aarch64-linux"; };
        };
        specialArgs = { inherit self; };
      };

      defaults = { config, lib, pkgs, ... }: {
        # disable remote deployment by default
        # (can stil build locally with nixos-rebuild)
        deployment.targetHost = lib.mkDefault null;
        deployment.buildOnTarget = lib.mkDefault true;

        imports = [
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          { nixpkgs.overlays = [ nur.overlay ]; }
          agenix.nixosModules.default
          birdsong.nixosModules.default
          actual.nixosModules.default
          ./common
          ./services
          (builtins.toPath "${randomcat}/services/default.nix")
        ];
      };

      yevaud.deployment.targetHost = "yevaud.birdsong.network";
      orm.deployment.targetHost = "orm.birdsong.network";
      kalessin.deployment.targetHost = "kalessin.birdsong.network";

      kilgharrah.imports = [ ./hosts/kilgharrah ];
      tohru.imports = [ ./hosts/tohru ];
      yevaud.imports = [ ./hosts/yevaud ];
      orm.imports = [ ./hosts/orm ];
      kalessin.imports = [ ./hosts/kalessin ];
    };

    # TODO: have this work on other systems too
    devShells."x86_64-linux".default =
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in
      pkgs.mkShell {
        packages = [
          pkgs.colmena
          agenix.packages.${system}.default
          plasma-manager.packages.${system}.rc2nix
        ];
      };
  };
}
