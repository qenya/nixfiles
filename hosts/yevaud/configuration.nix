{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../users/qenya.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yevaud";
  networking.hostId = "09673d65";

  time.timeZone = "Etc/UTC";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Allow remote root login only from home network
  # TODO: Find a less hacky way of doing remote deployment
  users.users.root.openssh.authorizedKeys.keys = config.users.users.qenya.openssh.authorizedKeys.keys;
  services.openssh.extraConfig = "Match Address 45.14.17.200\n    PermitRootLogin prohibit-password";

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  services.fail2ban.enable = true;

  services.nginx = {
    enable = true;

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

    virtualHosts = {
      "git.katherina.rocks" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://[::1]:3000/";
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "accounts@katherina.rocks";
  };

  services.forgejo = {
    enable = true;
    stateDir = "/data/forgejo";
    settings = {
      DEFAULT.APP_NAME = "git.katherina.rocks";
      cache = {
        ADAPTER = "twoqueue";
        HOST = ''{"size": 100, "recent_ratio": 0.25, "ghost_ratio": 0.5}'';
      };
      database = {
        DB_TYPE = "sqlite3";
        SQLITE_JOURNAL_MODE = "WAL";
      };
      security.LOGIN_REMEMBER_DAYS = 365;
      server = {
        DOMAIN = "git.katherina.rocks";
        HTTP_PORT = 3000;
        ROOT_URL = "https://git.katherina.rocks/";
      };
      service.DISABLE_REGISTRATION = true;
    };
  };

  system.stateVersion = "23.11";

}

