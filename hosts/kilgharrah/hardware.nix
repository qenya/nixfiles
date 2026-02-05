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

  services.printing.drivers = [ pkgs.hplip ];

  # enable playing from bluray drive
  boot.kernelModules = [ "sg" ];
  environment.systemPackages = [
    ((pkgs.vlc.override {
      libbluray = (pkgs.libbluray.override {
        withJava = true;
        withAACS = true;
        withBDplus = true;
      });
    }).overrideAttrs (originalAttrs: {
      buildInputs = originalAttrs.buildInputs ++ [ pkgs.libdvdcss ];
      # TODO: nixpkgs bug: libbluray needs patching to look at the nix store path of jdk17 when searching for a jdk
      # as a workaround, wrap vlc and set JAVA_HOME, which it uses instead of searching when specified
      nativeBuildInputs = originalAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
      postFixup = ''
        ${originalAttrs.postFixup or ""}
        wrapProgram $out/bin/vlc --set JAVA_HOME ${pkgs.jdk17.home}
      '';
    }))
  ];
}
