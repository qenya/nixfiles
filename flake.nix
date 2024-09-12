{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nur.url = "github:nix-community/NUR";

    agenix = {
      url = "github:ryantm/agenix?tag=0.15.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };

    birdsong.url = "git+https://git.qenya.tel/qenya/birdsong?ref=main";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, nur, agenix, birdsong, ... }: {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = {
          kalessin = import nixpkgs { system = "aarch64-linux"; }; # TODO: this should be generated from the host config somehow
        };
      };

      defaults = { name, nodes, config, ... }: {
        networking.hostName = name;

        nix.settings.experimental-features = "nix-command flakes";
        nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
        nixpkgs.config.allowUnfree = true;

        nixpkgs.config.packageOverrides = pkgs: {
          agenix = agenix.packages.${config.nixpkgs.hostPlatform.system}.default;
          rc2nix = plasma-manager.packages.${config.nixpkgs.hostPlatform.system}.rc2nix;
        };
        nixpkgs.overlays = [ nur.overlay ];
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

        imports = [
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          agenix.nixosModules.default
          birdsong.nixosModules.default
          ./common
          ./services
        ];
      };

      kilgharrah.imports = [ ./hosts/kilgharrah ];
      tohru.imports = [ ./hosts/tohru ];

      yevaud = { name, nodes, ... }: {
        networking.hostId = "09673d65";
        deployment.targetHost = "yevaud.birdsong.network";

        imports = [
          ./hosts/yevaud/configuration.nix
        ];
      };

      orm = { name, nodes, ... }: {
        networking.hostId = "00000000";
        deployment.targetHost = "orm.birdsong.network";

        imports = [
          ./hosts/orm/configuration.nix
        ];
      };

      kalessin = { name, nodes, ... }: {
        networking.hostId = "534b538e";
        deployment = {
          targetHost = "kalessin.birdsong.network";
          buildOnTarget = true;
        };

        imports = [
          ./hosts/kalessin/configuration.nix
        ];
      };
    };
  };
}
