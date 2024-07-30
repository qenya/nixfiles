{ config, lib, pkgs, ... }:

# dconf is the configuration manager for GNOME.

# home-manager, in its infinite wisdom, sets `dconf.enable` to true by default.
# This is a problem because we don't want it to attempt to apply our settings on
# a system that doesn't actually have GNOME installed.

# To work around it, we create our own option `qenya.dconf.enable`, which
# defaults to false, and pass it to `dconf.enable`.

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.qenya.dconf;
in
{
  options.qenya.dconf = {
    enable = mkEnableOption "dconf";
  };

  config = {
    dconf.enable = config.qenya.dconf.enable;
  };

  imports = [
    # TODO: nix-ify other parts of GNOME config
    ./appearance.nix
    ./keyboard.nix
  ];
}
