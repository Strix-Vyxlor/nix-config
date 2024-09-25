{ inputs, systemSettings, ...}:
{
  home.packages = [
    inputs.zen-browser.packages."${systemSettings.system}".specific
  ];
  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = ["userapp-Zen" "Browser-KUTWU2.desktop"];
    };
  };
}
