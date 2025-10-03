{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    # enable = true;
    user = "qenya";
    dataDir = "/data/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "kilgharrah" = { id = "RDT7IGD-76FZ6LY-37PPB2W-DWPQRPR-LZ4AXF7-4GIIHYJ-RVXUUSG-ZXPN3AZ"; };
        "latias" = { id = "EN4W2SB-LB4AAZQ-6AQIE7G-S3BSCSP-V2EUNMM-KAQEHW3-PPAPGBO-PXRPWAL"; };
        "shaw" = { id = "NC7WMZS-GQETJYR-IAYGD65-GHTSTVP-VAAG43K-W7N3LO5-C5OQMZ2-DTK6YA7"; };
      };
      folders = {
        "Sync" = {
          id = "uln2v-zwzwj";
          path = "~/Sync";
          devices = [ "kilgharrah" "shaw" ];
        };
        
        "Documents" = {
          id = "alp59-7gs9s";
          path = "~/Documents";
          devices = [ "kilgharrah" "shaw" ];
        };
        "Music" = {
          id = "7xvkf-y62s7";
          path = "~/Music";
          devices = [ "kilgharrah" "shaw" ];
        };
        "Pictures" = {
          id = "tbmhx-ep7wk";
          path = "~/Pictures";
          devices = [ "kilgharrah" "shaw" ];
        };

        "ES-DE" = {
          id = "c1cbh-llw94";
          path = "~/ES-DE";
          devices = [ "kilgharrah" "latias" "shaw" ];
        };
        "ROMs" = {
          id = "dcze4-v6act";
          path = "~/ROMs";
          devices = [ "kilgharrah" "latias" "shaw" ];
        };
      };
    };
  };
}
