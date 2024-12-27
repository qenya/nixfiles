{ config, lib, pkgs, ... }:

{
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
      add_header Content-Security-Policy "default-src https: data: blob: ws: 'unsafe-inline' 'wasm-unsafe-eval'; object-src 'none'; base-uri 'self';" always;
      add_header Referrer-Policy strict-origin-when-cross-origin;
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      add_header X-Clacks-Overhead "GNU Terry Pratchett" always;
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "auto@qenya.tel";
  };
}