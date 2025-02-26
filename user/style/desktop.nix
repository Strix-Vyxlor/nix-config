{
  config,
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}: let
  background = "../../../themes" + ("/" + userSettings.theme) + "/background.png";
in {
  imports = [
    (./. + "../../../themes" + ("/" + userSettings.theme) + /icons.nix)
  ];
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
      kde.enable = true;
      gtk.enable = true;
      qt.enable = true;
    };
  };

  home = {
    file = {
      "Media/Pictures/background.png" = {
        source = ./. + background;
      };
      "Media/Pictures/logo" = {
        source = ../../themes/logo;
        recursive = true;
      };
    };

    #packages = with pkgs; [
    #  libsForQt5.qt5ct
    #  pkgs.libsForQt5.breeze-qt5
    #  libsForQt5.breeze-icons
    #  pkgs.noto-fonts-monochrome-emoji
    #];
  };
  # qt = {
  #   enable = true;
  #   style.package = pkgs.libsForQt5.breeze-qt5;
  #   style.name = "breeze-dark";
  #   platformTheme.name = "kde";
  # };

  # home.file = {
  #   ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./oomox-current.conf.mustache;
  #     extension = ".conf";
  #   };
  #   ".config/Trolltech.conf".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./Trolltech.conf.mustache;
  #     extension = ".conf";
  #   };
  #   ".config/kdeglobals".source = config.lib.stylix.colors {
  #     template = builtins.readFile ./Trolltech.conf.mustache;
  #     extension = "";
  #   };
  #   ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile ./qt5ct.conf);
  # };

  fonts.fontconfig.defaultFonts = {
    monospace = [userSettings.font];
    sansSerif = [userSettings.font];
    serif = [userSettings.font];
  };
}
