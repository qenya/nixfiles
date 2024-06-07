{ config, lib, pkgs, ... }:

{
  imports = [
    # TODO: nix-ify other parts of GNOME config
    ./appearance.nix
    ./keyboard.nix
  ];
}
