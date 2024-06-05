{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  # Allow remote root login only from home network
  # TODO: Find a less hacky way of doing remote deployment
  users.users.root.openssh.authorizedKeys.keys = config.users.users.qenya.openssh.authorizedKeys.keys;
  services.openssh.extraConfig = "Match Address 45.14.17.200\n    PermitRootLogin prohibit-password";
}