{ inputs, ... }:

{
  imports = [
    (builtins.toPath "${inputs.randomcat}/services/default.nix")
  ];
}
