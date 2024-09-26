{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/zip" = ["xarchiver.desktop"];
    };
    associations = {
      added = {
        "application/zip" = ["xarchiver.desktop"];
      };
    };
  };
}
