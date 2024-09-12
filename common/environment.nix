{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    lshw
    parted
    wget

    # network troubleshooting
    inetutils
    lsof
    tcpdump
    netcat # <3

    # used for nix config
    colmena
    agenix
    rc2nix
  ];

  environment.wordlist.enable = true;
}