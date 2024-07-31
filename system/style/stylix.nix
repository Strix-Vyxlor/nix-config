{ lib, pkgs, inputs, userSettings, ... }:
let
  themePath = "../../../themes" + ("/" + userSettings.theme ) + "/theme.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes" + ("/" + userSettings.theme) + "/polarity.txt"));
  background = "../../../themes" + ("/" + userSettings.theme) + "/background.png";
in 
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.autoEnable = false;
  stylix.polarity = themePolarity;
  # stylix.image = ./. + background;
  
  stylix.base16Scheme = ./. + themePath;
  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    serif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    sansSerif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
  };

  stylix.targets = {
    console.enable = true;
    plymouth.enable = true;
    nixos-icons.enable = true;
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
