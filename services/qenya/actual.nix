{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.qenya.services.actual;
in
{
  options.qenya.services.actual = {
    enable = mkEnableOption "Actual Budget";
    domain = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    fountain.services.reverse-proxy.enable = true;
    fountain.services.reverse-proxy.domains.${cfg.domain} = "http://127.0.0.1:5006/";

    services.actual = {
      enable = true;
      # nixos 25.05 is on actual-server 25.6.1 which contains an annoying bug
      # nixpkgs maintainers declined to backport a newer version, so get this from unstable for now
      # ref. https://github.com/NixOS/nixpkgs/issues/423541
      package = (import inputs.nixpkgs-unstable-small { system = "x86_64-linux"; }).actual-server;
      settings.port = 5006;
    };
  };
}
