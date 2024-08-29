{ config, lib, pkgs, ... }:

# dconf is the configuration manager for GNOME.

# home-manager, in its infinite wisdom, sets `dconf.enable` to true by default.
# This is a problem because we don't want it to attempt to apply our settings on
# a system that doesn't actually have GNOME installed. So, we override the
# default to false.

let inherit (lib) mkDefault;
in {
  dconf.enable = mkDefault false;

  imports = [
    # TODO: nix-ify other parts of GNOME config
    ./appearance.nix
    ./keyboard.nix
  ];
}
