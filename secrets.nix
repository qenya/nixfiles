let
  keys = import ./keys.nix;

  commonKeys = keys.users.qenya;

  secrets = with keys; {
    ftp-userDb-qenya = [ machines.kilgharrah ];
    user-password-kilgharrah-qenya = [ machines.kilgharrah ];
    user-password-tohru-qenya = [ machines.tohru ];
    wireguard-peer-orm = [ machines.orm ];
    wireguard-peer-tohru = [ machines.tohru ];
    wireguard-peer-yevaud = [ machines.yevaud ];
  };
in
builtins.listToAttrs (
  map
    (secretName: {
      name = "secrets/${secretName}.age";
      value.publicKeys = secrets."${secretName}" ++ commonKeys;
    })
    (builtins.attrNames secrets)
)
