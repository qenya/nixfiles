{ config, lib, pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  # this is an old laptop
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  powerManagement.cpuFreqGovernor = "performance"; # ondemand not supported with this CPU, only performance or powersave
}

