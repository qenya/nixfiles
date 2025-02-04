{
  machines = {
    kilgharrah = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgGF3gzzlMbxxk3UAAgHJ7sDdjqtrw7UW16M1XhXtz2 root@kilgharrah";
    elucredassa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+Y/vqGNc1wXUAg4XMAAcLupkggywj2LpYDwA16ONbH root@elucredassa";
    tohru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8wuGzF0Y7SaH9aimo3SmCz99MTQwL+rEVhx0jsueU root@tohru";
    yevaud = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHUAgyQhl390yUObLUI+jEbuNrZ2U6+8px628DolD+T root@yevaud";
    orm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc9rkcdOVWozBFj3kLVnSyUQQbyyH+UG+bLawanQkRQ root@orm";
    kalessin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPt3iSSmgnlsv1/jafgZgI7o8UuXzcAL45hID2ThfS8 root@kalessin";
    shaw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMC0AomCZZiUV/BCpImiV4p/vGvFaz5QNc+fJLXmS5p root@shaw";
  };

  users = {
    qenya = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjBuuxo+w3yED0aPnsNb8S90p/GgBqFEG9K4ETZ5Wkq qenya@kilgharrah"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEmkV9arotms79lJPsLHkdzAac4eu3pYS08ym0sB/on qenya@tohru"
    ];
    randomcat = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHagOaeTR+/7FL9sErciMw30cmV/VW8HU7J3ZFU5nj9 janet@randomcat.org"
    ];
    trungle = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAA57legzdIcYTVVri4Wc0CvgWefbRhmUqhu0F/5f8FB reuben@glenda-artix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAuYWPfYVKdjBY/gBMt2n11Seb+hMqjui1PQ6C4ph8i richard@tress"
    ];
    gaelan = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFbDvPKnPXe+58QgdgK8yZ3Ac9dkJdtHJ3pQwWhszM7McwCzCEO/b940K0orLjfeUruC+hGJZO8heIh0J6JwSK907aS2wpHofU9q7bMT0PYeuHrSb2iFrOFIkTIWpO8hnWad8TGKOlOdNTKEdB9zwxXEKTFb9QW1Z27Zql79W44jUvaOTb7gKUps37O77lHEJDModaRsXS2523pSbrTZKDwZ73+S0ECeNUwwzLUyOOUHfENEXnM18hWm8mV0iU7kxFcmS33z9rWlWPNiCXnBnSi5LPgBarYOAqQf56f9OisafKqvc3uX+yn0kGCDWglVGUkbhfSIP9+w+yv/h/NJWIJlJC92ndbktAqAQW4gb7lXYxpbdoWcmqEy97q0e2vyBdhcVXwZ+0q+U8I74m8trq36ieHDtLKYkiFBX6zvrLP4I5OZU+EecdV2HcMoU8HNa5u1mvG+oHaEgkR70a5cQtrPzWLS/OMLqvWL39vO7RNskzwWCSuWScxDGitr+BunRRbL4aKNkkPjdDlIqb/SfSrFikOo75f5Ku4I32nbM7SNpIjA4cHe50rx1UB8lT+RwHdxL99OdoxIPCe6OLA5uT8VGPXkvqd/ZIFOL2HaM+uPLaYbjwLrHlwSOLgGbehmsSD369EXv6NAc5wbzsSLJQhJ66d5unnzGjn4dRt9sbDw== gbs@canishe.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHId+2dJYiZK++p8lu9Bax0J29JjeuU4qcIBdLwEz3lm gbs@canishe.com"
    ];
  };
}
