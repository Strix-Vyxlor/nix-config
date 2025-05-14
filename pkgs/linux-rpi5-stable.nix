{
  lib,
  buildLinux,
  fetchFromGitHub,
  ...
}: let
  modDirVersion = "6.12.25";
  tag = "stable_20250428";
in
  (buildLinux {
    version = "${modDirVersion}-${tag}";
    inherit modDirVersion;
    pname = "linux-rpi5-stable";

    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      rev = tag;
      hash = "sha256-jVvJJJP4wSJm91jOz8QMXIujjGZ+IisTMCvusxarons=";
    };

    defconfig = "bcm2712_defconfig";
    structuredExtraConfig = with lib.kernel; {
      DRM_SUN4I = no;
    };
    ignoreConfigErrors = true;

    features = {
      efiBootStub = false;
    };

    meta = with lib; {
      description = "stable linux kernel for rpi5";
      homepage = "https://github.com/raspberrypi/linux";
      platforms = ["aarch64-linux"];
      license = licenses.gpl2;
    };
  }).overrideAttrs (oldAttrs: {
    postConfigure = ''
      # The v7 defconfig has this set to '-v7' which screws up our modDirVersion.
      sed -i $buildRoot/.config -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
      sed -i $buildRoot/include/config/auto.conf -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
    '';
  })
