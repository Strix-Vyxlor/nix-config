{
  config,
  pkgs,
  branch,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  strixos = {
    inherit branch;
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
    };
    style = {
      theme.generateWithImage = ../../themes/background/golden-hour-mountain.jpg;
      targets.btop = true;
      desktop = {
        enable = true;
        cursor = {
          name = "BreezeX-RoséPine";
          package = pkgs.rose-pine-cursor;
          size = 24;
        };
      };
    };
    xdg = {
      enable = true;
      userDirs = true;
      mime = true;
    };
    shell = {
      defaultShell = "nushell";
      nushell = {
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
      };
      cli = {
        git = {
          enable = true;
          gh = true;
        };
        tmux.enable = true;
        cava = true;
        yazi = {
          enable = true;
          makeDefault = true;
        };
      };
      browser = {
        brave.enable = true;
        zen-browser = {
          enable = true;
          makeDefault = true;
        };
      };
      editor.strixvim = true;
      graphics.aseprite = true;
      media = {
        discord = true;
        spicetify = {
          enable = true;
          customApps = a: with a; [newReleases lyricsPlus];
          extensions = e: with e; [fullAppDisplay hidePodcasts];
          style.theme = "hazy";
        };
      };
    };
    desktop = {
      hyprland = {
        enable = true;
        #hyprcursorTheme = "Nordzy-Hyprcursors";
        keymap = "be";
        monitors = [
          "eDP-1,1920x1200,0x0,1"
          "HDMI-A-1,1920x1080,-1920x0,1"
        ];
        extraSettings = {
          env = [
            "HYPRCURSOR_THEME,rose-pine-hyprcursor"
          ];
          exec-once = [
            "nm-applet"
            "blueberry-tray"
          ];
          bind = [
            ",XF86Favorites, exec, spotify"
            ",XF86HangupPhone, exec, playerctl next"
            ",XF86NotificationCenter, exec, playerctl previous"
            ",XF86PickupPhone, exec, playerctl play-pause"
          ];
          windowrulev2 = ["tile,class:(Aseprite)"];
        };
        apps = {
          osd = "swayosd";
          notification = "swaync";
          waybar = {
            brightness = true;
            battery = true;
            temperature = true;
          };
        };
        plugins.hyprexpo = true;
      };
    };
  };

  home.packages = with pkgs; [
    git
    ffmpeg

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

    blueberry
    networkmanagerapplet
    qalculate-gtk
    strix-theme-generator
    rose-pine-hyprcursor
  ];

  programs.zix = {
    enable = true;
    config.root_command = "sudo";
  };

  home.stateVersion = "24.11";
}
