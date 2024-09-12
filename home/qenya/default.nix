{
  imports = [
    ./dconf
    ./plasma
    ./cli.nix
    ./firefox.nix
    ./git.nix
    ./tmux.nix
    ./vscode.nix
    ./xdg-mime-apps.nix
    ./zsh.nix
  ];
  
  home.stateVersion = "23.11";
}
