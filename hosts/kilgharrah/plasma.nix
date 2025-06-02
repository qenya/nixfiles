{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkForce;
in
{
  services.xserver.displayManager.gdm.enable = mkForce false;
  services.xserver.desktopManager.gnome.enable = mkForce false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "modern" ];
    })
  ];

  home-manager.users.qenya = { pkgs, ... }: {
    imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    programs.plasma = {
      enable = true;
      overrideConfig = true;

      workspace = {
        lookAndFeel = "Catppuccin-Mocha-Mauve";
        colorScheme = "CatppuccinMochaMauve";
        splashScreen.engine = "KSplashQML";
        splashScreen.theme = "Catppuccin-Mocha-Mauve";
        windowDecorations.library = "org.kde.kwin.aurorae";
        windowDecorations.theme = "__aurorae__svg__CatppuccinMocha-Modern";
      };

      # For the moment, this hosts some network-accessible services, so we want it on 24/7
      powerdevil.AC.autoSuspend.action = "nothing";

      panels = [
        # Dock
        {
          height = 49; # 41 * 1.2
          lengthMode = "fit";
          location = "bottom";
          alignment = "center";
          hiding = "dodgewindows";
          widgets = [{
            name = "org.kde.plasma.icontasks";
            config.General = {
              fill = false;
              iconSpacing = 2;
              launchers = lib.concatStringsSep "," [
                "applications:firefox.desktop"
                "applications:codium-url-handler.desktop"
                "applications:steam.desktop"
                "applications:discord.desktop"
                "applications:com.obsproject.Studio.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.plasma-systemmonitor.desktop"
              ];
              maxStripes = 1;
              showOnlyCurrentDesktop = false;
              showOnlyCurrentScreen = false;
            };
          }];
          screen = "all";
        }

        # Top bar
        {
          height = 29; # 24 * 1.2
          location = "top";
          alignment = "left";
          floating = false;
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config.General = {
                lengthFirstMargin = 7;
              };
            }
            { name = "org.kde.plasma.panelspacer"; }
            {
              name = "org.kde.plasma.digitalclock";
              config.Appearance = {
                autoFontAndSize = false;
                customDateFormat = "dddd, d MMM";
                dateDisplayFormat = "BesideTime";
                dateFormat = "custom";
                fontFamily = "Inter";
                fontStyleName = "Bold";
                fontWeight = 700;
                boldText = true;
                showWeekNumbers = true;
              };
            }
            { name = "org.kde.plasma.panelspacer"; }
            { name = "org.kde.plasma.systemtray"; }
          ];
          screen = "all";
        }
      ];
    };
  };
}
