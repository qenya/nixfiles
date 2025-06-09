{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--login-server" "https://headscale.unspecified.systems" ];
    extraDaemonFlags = [ "--no-logs-no-support" ]; # disable telemetry
  };

  systemd.services.tailscaled-autoconnect = {
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      sleep 2 # wait for tailscaled to settle
      ${lib.getExe config.services.tailscale.package} up --reset ${lib.escapeShellArgs config.services.tailscale.extraUpFlags}
    '';
  };

  networking.domain = "birdsong.network";

  programs.ssh.knownHosts = {
    "reese.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPd0qGxvcMLDwX1bqYpwOUL5c/CIgBllMFr+bGkwiwAn root@reese"; };
    "bear.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZ9Kn1CIcDHaleKHf7zO6O30Rbxs/FwL0/Ie+mEjZJr root@bear"; };
    "shaw.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMC0AomCZZiUV/BCpImiV4p/vGvFaz5QNc+fJLXmS5p root@shaw"; };
    "groves.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQNZ/Q+x7mDYfYXftpZpWkfPByyMBbYmVFobM4vSDW2 root@groves"; };
    "tohru.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8wuGzF0Y7SaH9aimo3SmCz99MTQwL+rEVhx0jsueU root@tohru"; };
    "yevaud.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHUAgyQhl390yUObLUI+jEbuNrZ2U6+8px628DolD+T root@yevaud"; };
    "orm.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc9rkcdOVWozBFj3kLVnSyUQQbyyH+UG+bLawanQkRQ root@orm"; };
    "kalessin.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPt3iSSmgnlsv1/jafgZgI7o8UuXzcAL45hID2ThfS8 root@kalessin"; };
    "tehanu.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1fNylfLo7Z8m/DroRlj7cHMLhYL7boP3r/upVrtMJQ root@tehanu"; };
    "kilgharrah.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgGF3gzzlMbxxk3UAAgHJ7sDdjqtrw7UW16M1XhXtz2 root@kilgharrah"; };
    "elucredassa.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+Y/vqGNc1wXUAg4XMAAcLupkggywj2LpYDwA16ONbH root@elucredassa"; };
    "carter.birdsong.network" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHHHYG6A995Po05+JXQsvB79ZoIiSOJnW6AiJgVYPic root@carter"; };
  };
}
