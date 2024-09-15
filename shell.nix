let
  shell = (import
    (fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/refs/tags/v1.0.1.tar.gz";
      sha256 = "0m9grvfsbwmvgwaxvdzv6cmyvjnlww004gfxjvcl806ndqaxzy4j";
    })
    { src = ./.; }).shellNix;
in
shell.devShells.${builtins.currentSystem}
