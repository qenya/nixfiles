let
  shell = (import
    (fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/refs/tags/v1.0.1.tar.gz";
      sha256 = "0jm6nzb83wa6ai17ly9fzpqc40wg1viib8klq8lby54agpl213w5";
    })
    { src = ./.; }).shellNix;
in
shell.devShells.${builtins.currentSystem}
