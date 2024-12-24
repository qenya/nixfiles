{ config, pkgs, inputs, ... }:

{
  config = {
    services.sanoid = {
      enable = true;
      extraArgs = [ "--verbose" ];

      # Local snapshots for important datasets
      templates."production" = {
        yearly = 0;
        monthly = 3;
        daily = 30;
        hourly = 36;
        autosnap = true;
        autoprune = true;
      };

      # Reduced-retention version for datasets that are backed up to the NAS
      templates."safe" = {
        yearly = 0;
        monthly = 0;
        daily = 7;
        hourly = 24;
        autosnap = true;
        autoprune = true;
      };

      # datasets."rpool_sggau1/reese/system" = {
      #   useTemplate = [ "safe" ];
      #   recursive = "zfs";
      # };
    };
  };
}