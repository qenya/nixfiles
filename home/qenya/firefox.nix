{ config, lib, pkgs, osConfig, inputs, ... }:

let
  inherit (lib) mkIf;
  isGraphical = osConfig.services.xserver.enable;
in
{
  programs.firefox = lib.mkIf isGraphical {
    enable = true;
    languagePacks = [ "en-GB" ];

    policies = {
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # 1Password
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        # Disqus Auto-Expander
        "disqus-auto-expander@john30013.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/disqus-auto-expander/latest.xpi";
          installation_mode = "force_installed";
        };
        # Indie Wiki Buddy
        "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
          installation_mode = "force_installed";
        };
        # SteamDB
        "firefox-extension@steamdb.info" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/steam-database/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.default = {
      settings = {
        "browser.startup.page" = 3; # resume previous session
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # disable prefetch?

        # DNS over HTTPS
        "network.trr.custom_uri" = "https://base.dns.mullvad.net/dns-query";
        "network.trr.excluded-domains" = "detectportal.firefox.com";
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://base.dns.mullvad.net/dns-query";

        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;

        "dom.security.https_only_mode" = true;
        "browser.contentblocking.category" = "strict"; # Enhanced Tracking Protection
        # I think these are implied by the above
        # "privacy.donottrackheader.enabled" = true;
        # "privacy.trackingprotection.enabled" = true;
        # "privacy.trackingprotection.emailtracking.enabled" = true;
        # "privacy.trackingprotection.socialtracking.enabled" = true;

        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;

        "dom.private-attribution.submission.enabled" = false; # disable "Privacy-Preserving Attribution for Advertising"
        "extensions.autoDisableScopes" = 0; # automatically enable extensions installed through nix

        # external password manager
        "signon.rememberSignons" = false;
        "extensions.formautofill.creditCards.enabled" = false;
      };
    };
  };
}
