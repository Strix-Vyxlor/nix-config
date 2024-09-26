{
  config,
  pkgs,
  systemSettings,
  ...
}: {
  boot.kernelPackages = systemSettings.kernel;
  boot.consoleLogLevel = 0;
}
