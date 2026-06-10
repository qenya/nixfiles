{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.flake = {
    source = lib.cleanSource pkgs.path;
    setNixPath = true;
    setFlakeRegistry = true;
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "@wheel" ];

  # Temporary preparing for upgrade to 26.05
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs.overlays = [
    (final: prev: {
      inherit (final.lixPackageSets.stable)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
    })
  ];
}
