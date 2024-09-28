{ config, lib, pkgs, ... }:

{
  randomcat.services.zfs.datasets = {
    "rpool_albion/srv" = { mountpoint = "none"; };
    "rpool_albion/srv/ftp" = { mountpoint = "/srv/ftp"; };
  };

  age.secrets.ftp-userDb-qenya = {
    # To update this, see the nixos docs for services.vsftpd.userDbPath. Note
    # that the command it gives to create a userDb, if applied to an *existing*
    # userDb, will *add* the entries from the source file, overwriting any
    # entries with the same username but leaving other existing entries intact.
    # Also note the database format does not salt hashes.
    file = ../../secrets/ftp-userDb-qenya.age;

    # we have to specify this manually because pam_userdb strips the extension
    path = "/etc/vsftpd/userDb.db";
  };

  services.vsftpd = {
    enable = true;
    localUsers = true;
    forceLocalLoginsSSL = true;
    forceLocalDataSSL = true;
    rsaCertFile = "${config.security.acme.certs."ftp.qenya.tel".directory}/fullchain.pem";
    rsaKeyFile = "${config.security.acme.certs."ftp.qenya.tel".directory}/key.pem";

    enableVirtualUsers = true;
    userlistDeny = false; # turn userlist from a denylist into an allowlist
    userlist = [ "qenya" ]; # this is just a list of the users in the userDb
    userDbPath = "/etc/vsftpd/userDb";

    localRoot = "/srv/ftp";

    extraConfig = ''
      # nothing in the default cipher suite is enabled in modern ssl clients!
      ssl_ciphers=HIGH

      # set this to something firewallable
      pasv_min_port=51000
      pasv_max_port=51099

      # don't bother with upgrading to TLS, just listen on FTPS only
      implicit_ssl=YES
      listen_port=990
    '';
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "ftp.qenya.tel" = {
        forceSSL = true;
        useACMEHost = "ftp.qenya.tel";
        locations."/".return = "503";
      };
    };
  };

  security.acme.certs = {
    "ftp.qenya.tel" = {
      webroot = "/var/lib/acme/acme-challenge";
      group = "acme_ftp.qenya.tel";
    };
  };

  users.groups."acme_ftp.qenya.tel".members = [
    "vsftpd" # not configurable in the vsftpd nixos module
    config.services.nginx.group
  ];

  networking.firewall.allowedTCPPorts = [ 990 80 443 ];
  networking.firewall.allowedTCPPortRanges = [{ from = 51000; to = 51099; }];
}
