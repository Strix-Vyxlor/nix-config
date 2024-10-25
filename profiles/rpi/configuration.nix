{systemSettings, ...}: {
  imports = [(./. + ("/" + systemSettings.subprofile) + "/configuration.nix")];
}
