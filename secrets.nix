let
  keys = import ./keys.nix;

  secrets = with keys; {
    ftp-userDb-qenya = [ machines.kilgharrah ] ++ keys.users.qenya;
    user-password-kilgharrah-qenya = [ machines.kilgharrah ] ++ keys.users.qenya;
    user-password-tohru-qenya = [ machines.tohru ] ++ keys.users.qenya;
    protonvpn-pennykettle1 = [ machines.yevaud ] ++ keys.users.qenya;
  };
in
builtins.listToAttrs (
  map
    (secretName: {
      name = "secrets/${secretName}.age";
      value.publicKeys = secrets."${secretName}";
    })
    (builtins.attrNames secrets)
)
