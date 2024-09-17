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

      "qenya@shaw".imports = [
        self.homeManagerModules."qenya"
        ./hosts/shaw/home.nix
      ];
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = {
          kalessin = import nixpkgs { system = "aarch64-linux"; }; # TODO: this should be generated from the host config somehow
        };
      };

      defaults = { name, nodes, ... }: {
        networking.hostName = name;

        nix.settings.experimental-features = "nix-command flakes";
        nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
        nixpkgs.config.allowUnfree = true;

        nixpkgs.overlays = [ nur.overlay ];

        # TODO: make this or something like it work without infinite recursion
        # home-manager.users."qenya" = lib.mkIf (config.users.users ? "qenya") self.homeManagerModules."qenya";
        home-manager.users."qenya" = self.homeManagerModules."qenya";

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
