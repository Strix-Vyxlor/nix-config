final: prev: {
  papirus-nord = prev.papirus-nord.override {accent = "auroramagenta";};
  linux_rpi5 = final.linux_rpi4.override {
    rpiVersion = 5;
    argsOverride.defconfig = "bcm2712_defconfig";
  };
  strix-theme-generator = final.callPackage ./pkgs/stg {};
  rose-pine-hyprcursor = final.callPackage ./pkgs/rose-pine-hyprcursor {};
  # HACK: workaround for module not found error
  makeModulesClosure = x:
    prev.makeModulesClosure (x // {allowMissing = true;});
}
