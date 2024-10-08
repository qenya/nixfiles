{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
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