{pkgs, ...}: {
  gtk.cursorTheme = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  stylix.cursor = {
    package = pkgs.vimix-cursors;
    name = "Nordzy-cursors";
    size = 24;
  };

  gtk.iconTheme = {
    package = pkgs.papirus-nord.override {accent = "auroramagenta";};
    name = "Papirus-Dark";
  };
}
