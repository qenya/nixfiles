let
  keys = import ./keys.nix;

  commonKeys = keys.users.qenya;

  secrets = with keys; {
    wireguard-hub = [ machines.orm ];
    wireguard-peer-orm = [ machines.orm ];
    wireguard-peer-tohru = [ machines.tohru ];
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
