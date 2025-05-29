{ config, lib, pkgs, osConfig, ... }:

# Feishin ideally wants to see mpv at runtime, but this isn't catered for by
# the derivation in nixpkgs as it isn't strictly necessary.
# An easier way to do this would be to write mpv's full nix store path to
# Feishin's config. But Feishin has one JSON file for config and state, and
# we'd rather not overwrite the latter. Until and unless home-manager grows
# support for partially patching files, we live with this.

let
  inherit (lib) mkIf;
  isGraphical = osConfig.services.xserver.enable;
in
{
  home.packages = mkIf isGraphical [
    (pkgs.feishin.overrideAttrs (originalAttrs: {
      buildInputs = originalAttrs.buildInputs ++ [ pkgs.mpv ];
      postFixup = ''
        ${originalAttrs.postFixup or ""}
        wrapProgram $out/bin/feishin --prefix PATH : ${lib.makeBinPath [ pkgs.mpv ]}
      '';
    }))
  ];
}
