{...}: {
  xdg.mimeApps = {
    defaultApplications = {
      "application/zip" = "xarchiver.desktop";
      "application/x-compressed-tar" = "xarchiver.desktop";
      "application/x-xz-compressed-tar" = "xarchiver.desktop";
      "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
    };
    associations = {
      added = {
        "application/zip" = "xarchiver.desktop";
        "application/x-compressed-tar" = "xarchiver.desktop";
        "application/x-xz-compressed-tar" = "xarchiver.desktop";
        "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
        "application/x-tar" = "xarchiver.desktop";
      };
    };
  };
}
