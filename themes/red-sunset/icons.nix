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
    package = pkgs.vimix-icon-theme;
    name = "Vimix-ruby-dark";
  };

  stylix.iconTheme = {
    enable = true;
    package = pkgs.vimix-icon-theme;
    dark = "Vimix-ruby-dark";
    light = "Vimix-ruby";
  };
}
