{
  imports = [
    ./dconf
    ./plasma
    ./firefox.nix
    ./fontconfig.nix
    ./git.nix
    ./packages.nix
    ./tmux.nix
    ./vscode.nix
    ./xdg-mime-apps.nix
    ./zsh.nix
  ];
  
  home.stateVersion = "23.11";
}
