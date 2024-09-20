{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tree # like `ls -R` but nicer
    units

    # Extremely important
    fortune
    cowsay
    lolcat
  ];

  programs.btop.enable = true;
}
