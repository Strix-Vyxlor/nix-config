{pkgs, ...}: {
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
    package = pkgs.papirus-nord.override {accent = "auroramagentab";};
    name = "Papirus-Dark";
  };
}
