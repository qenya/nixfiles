# { config, lib, pkgs, ... }:

{
  dconf = {
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        # These are largely useless on most normal systems
        # and conflict with VS Code's default keybinds for "Copy Line Up/Down"
        move-to-workspace-up = [ ];
        move-to-workspace-down = [ ];
      };
    };
  };
}
