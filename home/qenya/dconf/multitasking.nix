{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };
  };
}
