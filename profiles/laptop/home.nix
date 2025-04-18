{
  config,
  pkgs,
  userSettings,
  lib,
  ...
}: {
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../user/style/stylix.nix
    ../../user/style/desktop.nix
    ../../themes/nerd-fonts.nix
    ../../user/shell/sh.nix
    (./. + "../../../user/app/editor" + ("/" + userSettings.editor) + ".nix")
    ../../user/app/git/git.nix
    ../../user/app/git/gh.nix
    (./. + "../../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
    (./. + "../../../user/app/browser" + ("/" + userSettings.browser) + ".nix")
    ../../user/app/browser/brave.nix

    ../../user/app/graphics/aseprite.nix
    ../../user/app/graphics/rawtherepee.nix
    ../../user/app/spotify/spicetify.nix
    ../../user/app/office/onlyoffice.nix
    (import ../../user/app/comms/discord/discord.nix {
      style = true;
      inherit pkgs;
      inherit config;
      inherit lib;
    })
    ../../user/lang/cc/cc.nix

    ../../user/app/console/cava.nix
    ../../user/app/console/tmux.nix

    ../../user/app/games/minecraft.nix
    ../../user/app/games/heroic.nix
    ../../user/app/games/utils.nix
    ../../user/app/games/retroarch.nix
    ../../user/app/games/dolphin.nix
    ../../user/app/graphics/blockbench.nix

    ../../user/app/etc/reaper.nix
  ];

  home.packages = with pkgs; [
    git
    ffmpeg
    userSettings.fontPkg
    lmms
    polyphone
    musescore
    moonlight-qt
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
