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
  ];

  environment.wordlist.enable = true;
}