{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    keepassxc
    amberol
    foliate
    nicotine-plus

    # games
    openttd
    prismlauncher
    nur.repos.qenya.digital-a-love-story
    nur.repos.qenya.dont-take-it-personally-babe
  ];
}
