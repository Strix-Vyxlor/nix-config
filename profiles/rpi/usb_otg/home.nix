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

  home.packages = with pkgs; [
    git
  ];

  home.file.".config/zix/conf.toml" = {
    text = ''
      flake_path = ".nix-config"
      hostname = "default"
      root_command = "doas"
    '';
    executable = false;
  };

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
    extraConfig = {
      XDG_NIX_CONFIG_DIR = "${config.home.homeDirectory}/.nix-config";
    };
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  news.display = "silent";

  home.stateVersion = "24.05";
}
