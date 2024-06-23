{ config, lib, pkgs, ... }:

{
  # CLI utilities I get frustrated if I'm missing
  environment.systemPackages = with pkgs; [
    git
    inetutils
    lshw
    parted
    wget
  ];

  environment.wordlist.enable = true;
}