{
  config,
  pkgs,
  userSettings,
  ...
}: {
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../user/style/stylix.nix
    ../../user/shell/sh.nix
    (./. + "../../../user/app/editor" + ("/" + userSettings.editor) + ".nix")
    ../../user/app/git/git.nix
    ../../user/app/git/gh.nix
    ../../user/lang/cc/cc.nix
    ../../user/app/console/tmux.nix
  ];

  home.file.".config/zix/conf.toml" = {
    text = ''
      flake_path = ".nix-config"
      hostname = "default"
      root_command = "doas"
    '';
    executable = false;
  };

  home.packages = with pkgs; [
    git
  ];

  home.stateVersion = "24.05";
}
