{ config, lib, pkgs, ... }:

{
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
      add_header Content-Security-Policy "default-src https: data: 'unsafe-inline'; object-src 'none'; base-uri 'none';" always;
      add_header Referrer-Policy strict-origin-when-cross-origin;
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      add_header X-Clacks-Overhead "GNU Terry Pratchett";
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "accounts@katherina.rocks"; # TODO: replace with more appropriate email
  };
}