{
  machines = {
    kilgharrah = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgGF3gzzlMbxxk3UAAgHJ7sDdjqtrw7UW16M1XhXtz2 root@kilgharrah";
    tohru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8wuGzF0Y7SaH9aimo3SmCz99MTQwL+rEVhx0jsueU root@tohru";
    yevaud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHUAgyQhl390yUObLUI+jEbuNrZ2U6+8px628DolD+T root@yevaud";
    orm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc9rkcdOVWozBFj3kLVnSyUQQbyyH+UG+bLawanQkRQ root@orm";
  };

  users = {
    qenya = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjBuuxo+w3yED0aPnsNb8S90p/GgBqFEG9K4ETZ5Wkq qenya@kilgharrah"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEmkV9arotms79lJPsLHkdzAac4eu3pYS08ym0sB/on qenya@tohru"
    ];
    randomcat = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHagOaeTR+/7FL9sErciMw30cmV/VW8HU7J3ZFU5nj9 janet@randomcat.org"
    ];
    richard = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAuYWPfYVKdjBY/gBMt2n11Seb+hMqjui1PQ6C4ph8i richard@tress"
    ];
  };
}
