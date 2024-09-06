{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    # coming in 24.11
    # languagePacks = [ "en-GB" ];

    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];

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
      };
    };
  };
}
