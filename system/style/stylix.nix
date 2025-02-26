{
  lib,
  userSettings,
  plymouth ? false,
  ...
}: let
  themePath = "../../../themes" + ("/" + userSettings.theme) + "/theme.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt"));
in {
  stylix = {
    enable = true;

    autoEnable = false;
    polarity = themePolarity;
    base16Scheme = ./. + themePath;

    targets = {
      console.enable = true;
      plymouth.enable = plymouth;
      nixos-icons.enable = true;
    };
  };
}
