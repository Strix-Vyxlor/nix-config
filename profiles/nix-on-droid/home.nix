{
  config,
  pkgs,
  userSettings,
  ...
}: {
  programs.home-manager.enable = true;

  imports = [
    ../../user/shell/sh.nix
    ../../user/app/git/git.nix
    ../../user/app/git/gh.nix
    (./. + "../../../user/app/editor" + ("/" + userSettings.editor) + ".nix")
    ../../user/app/console/tmux.nix
    ../../user/style/stylix.nix
  ];

  home.packages = with pkgs; [
    git
  ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
  };

  news.display = "silent";

  home.file.".config/zix/conf.toml" = {
    text = ''
      nix_on_droid = true
      flake_path = ".nix-config"
      hostname = "default"
      root_command = "doas"
    '';
    executable = false;
  };

  home.stateVersion = "24.05";
}
