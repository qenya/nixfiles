{ config, lib, pkgs, ... }:

let
  inherit (lib) concatMapAttrs;
  keys = import ../keys.nix;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh.knownHosts = concatMapAttrs
    (host: key: {
      "${host}.birdsong.network".publicKey = key;
    })
    keys.machines;
}
