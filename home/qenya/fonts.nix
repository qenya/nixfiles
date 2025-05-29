{ config, lib, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf;
  isGraphical = osConfig.services.xserver.enable;
in
mkIf isGraphical {
  fonts.fontconfig = {
    enable = true;
  };

  home.packages = with pkgs; [
    meslo-lgs-nf
  ];

  programs.vscode.profiles.default.userSettings."terminal.integrated.fontFamily" = "MesloLGS NF";
}
