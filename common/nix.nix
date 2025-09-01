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

  # Dependency of jellyfin-media-player, which hasn't upgraded to Qt6 yet
  # Related tickets:
  # - https://github.com/NixOS/nixpkgs/pull/435067
  # - https://github.com/NixOS/nixpkgs/issues/437865
  # - https://github.com/jellyfin/jellyfin-media-player/issues/282
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
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
