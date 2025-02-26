{userSettings, ...}: let
  background = "../../../themes" + ("/" + userSettings.theme) + "/background.png";
in {
  stylix = {
    image = ./. + background;

    fonts = {
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
    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
