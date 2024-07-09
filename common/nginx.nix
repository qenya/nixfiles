{ config, lib, pkgs, ... }:

{
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig = ''
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      add_header 'Referrer-Policy' 'strict-origin-when-cross-origin';
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "accounts@katherina.rocks"; # TODO: replace with more appropriate email
  };
}