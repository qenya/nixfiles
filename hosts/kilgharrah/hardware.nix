{ config, lib, pkgs, ... }:

{
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  # # Downgrade to driver version 535 as 550 has problems with Wayland
  # hardware.nvidia.package =
  #   let
  #     rcu_patch = pkgs.fetchpatch {
  #       url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
  #       hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
  #     };
  #   in
  #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     version = "535.154.05";
  #     sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
  #     sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
  #     openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
  #     settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
  #     persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
  #     patches = [ rcu_patch ];
  #   };

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
