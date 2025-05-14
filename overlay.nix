final: prev: {
  papirus-nord = prev.papirus-nord.override {accent = "auroramagenta";};
  linux-rpi5-stable = final.callPackage ./pkgs/linux-rpi5-stable.nix {};
}
