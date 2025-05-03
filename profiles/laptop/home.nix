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
    (./. + "../../../user/app/editor" + ("/" + userSettings.editor) + ".nix")
    (./. + "../../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")

    (import ../../user/app/comms/discord/discord.nix {
      style = true;
      inherit pkgs;
      inherit config;
      inherit lib;
    })
    ../../user/lang/cc/cc.nix

    ../../user/app/console/cava.nix

    ../../user/app/games/minecraft.nix
    ../../user/app/games/heroic.nix
    ../../user/app/games/utils.nix
    ../../user/app/games/retroarch.nix
    ../../user/app/games/dolphin.nix
    ../../user/app/graphics/blockbench.nix

    ../../user/app/etc/reaper.nix
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
      graphics.aseprite = true;
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
