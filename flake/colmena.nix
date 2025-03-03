# https://git.lix.systems/the-distro/infra/src/commit/fbb23bf517206175764f154ddfd304b9ec501f87/colmena.nix
{ lib, ... }: {
  options.flake.colmena = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf (lib.mkOptionType {
        name = "NixOS module";
        description = "module containing NixOS options and/or config";
        descriptionClass = "noun";
        check = value: builtins.isAttrs value || builtins.isFunction value || builtins.isPath value;
        merge = loc: defs: {
          imports = map (def: def.value) defs;
        };
      });
      options.meta = lib.mkOption {
        type = lib.types.attrs;
      };
    };
  };
}
