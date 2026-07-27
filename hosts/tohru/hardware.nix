{ config, lib, pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  users.users.qenya.extraGroups = [ "scanner" "lp" ];
}

