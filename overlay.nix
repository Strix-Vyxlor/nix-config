final: prev: {
  papirus-nord = prev.papirus-nord.override {accent = "auroramagenta";};
  papirus-icon-theme = prev.papirus-icon-theme.override {color = "black";};
  linux_rpi5 = final.linux_rpi4.override {
    rpiVersion = 5;
    argsOverride.defconfig = "bcm2712_defconfig";
  };
  strix-theme-generator = final.callPackage ./pkgs/stg {};
  colorfull-papirus = final.callPackage ./pkgs/colorfull-papirus {};
  rose-pine-hyprcursor = final.callPackage ./pkgs/rose-pine-hyprcursor {};
  decky-loader = final.callPackage ./pkgs/decky-loader {};
  # HACK: workaround for module not found error
  makeModulesClosure = x:
    prev.makeModulesClosure (x // {allowMissing = true;});
}
