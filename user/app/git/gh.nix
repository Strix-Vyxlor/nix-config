{pkgs, ...}: {
  home.packages = [pkgs.gh];
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
