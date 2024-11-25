{
  # TODO: consider DRY-ing these
  imports = [
    ./gaelan.nix
    ./qenya.nix
    ./randomcat.nix
    ./trungle.nix
  ];

  users.mutableUsers = false;
}
