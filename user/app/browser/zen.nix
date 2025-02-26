{
  inputs,
  systemSettings,
  ...
}: {
  home.packages = [
    inputs.zen-browser.packages."${systemSettings.system}".default
  ];
}
