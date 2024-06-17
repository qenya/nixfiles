{ config, lib, pkgs, ... }:

{
  # Derived from https://github.com/srid/nixos-config/blob/master/home/tmux.nix

  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "a"; # `screen` muscle memory compatibility
    baseIndex = 1; # this is a UI, 0-indexing is not appropriate, fight me
    newSession = true; # skip the manual step
    escapeTime = 0; # otherwise I keep reflexively hammering Esc
    secureSocket = false; # make sessions survive user logout

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    mouse = true;

    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
