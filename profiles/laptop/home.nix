{
  config,
  pkgs,
  userSettings,
  systemSettings,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../user/style/desktop.nix
    ../../themes/nerd-fonts.nix
    (./. + "../../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")

  ];

  strixos = {
    inherit (systemSettings) branch;
    user = {
      inherit (userSettings) username name email;
    };
    style = {
      enable = true;
      theme.themeDir = ./. + "../../../themes" + ("/" + userSettings.theme);
      targets.btop = true;
    };
    xdg = {
      enable = true;
      userDirs = true;
      mime = true;
    };
    shell = {
      defaultShell = "nushell";
      nushell = {
        style = true;
        aliases = {
          ll = "ls -l";
          lla = "ls -la";
          tree = "eza --icons --tree";
          plaincat = "^cat";
          cat = "bat --plain";
          neofetch = "fastfetch";
        };
      };
      prompt = {
        prompt = "oh-my-posh";
        style = true;
      };
      integrations = {
        vivid = true;
        direnv = true;
        zoxide = true;
      };
    };
    programs = {
      games = {
        minecraft = true;
        heroic = true;
        mangohud = true;
        dolphin = true;
        retroarch = {
          enable = true;
          withCores = cores:
            with cores; [
              dolphin
              picodrive
              genesis-plus-gx
            ];
        };
      };
      cli = {
        git = {
          enable = true;
          gh = true;
        };
        tmux.enable = true;
      };
      browser = {
        brave.enable = true;
        zen-browser = {
          enable = true;
          makeDefault = true;
        };
      };
      editor.neovim = true;
      graphics.aseprite = true;
      discord = {
        enable = true;
        style = true;
      };
    };
  };

  home.packages = with pkgs; [
    git
    ffmpeg
    userSettings.fontPkg
    lmms
    polyphone
    musescore
    moonlight-qt
    gawk
    gnugrep
    gnused
    htop
    unzip
    gzip
    xz
    file
    gnutar
    bat
    eza
    btop
    fzf
  ];

  home.file.".config/zix/conf.toml" = {
    text = ''
      flake_path = ".nix-config"
      hostname = "default"
      root_command = "doas"
    '';
    executable = false;
  };

  home.stateVersion = "25.05";
}
