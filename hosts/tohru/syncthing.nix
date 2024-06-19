{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "qenya";
    dataDir = "/data/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "kilgharrah" = { id = "RDT7IGD-76FZ6LY-37PPB2W-DWPQRPR-LZ4AXF7-4GIIHYJ-RVXUUSG-ZXPN3AZ"; };
      };
      folders = {
        "Documents" = {
          id = "alp59-7gs9s";
          path = "~/Documents";
          devices = [ "kilgharrah" ];
        };
      };
    };
  };
}
