{ config, lib, pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  # this is an old laptop
  services.logind.lidSwitch = "ignore";
}

