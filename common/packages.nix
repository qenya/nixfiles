{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    git
    wget

    # hardware troubleshooting
    lshw
    parted
    smartmontools

    # network troubleshooting
    inetutils
    lsof
    tcpdump
    netcat # <3
    wireguard-tools
  ];

  environment.wordlist.enable = true;
}