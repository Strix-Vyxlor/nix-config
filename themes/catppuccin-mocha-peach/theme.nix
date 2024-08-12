{ pkgs, ... }:
{

  home.file.".config/Vencord/themes/stylix.css".source = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    hash = "sha256-/DuTnReHp/aCQeVVYtwRgaOLHq1oBcEjqd6gRcSLGmA=";
  };

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 24;
  };

  stylix.cursor = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 24;
  };

  gtk.iconTheme = {
    package = pkgs.vimix-icon-theme;
    name = "Vimix-Black-dark";
  };
}
