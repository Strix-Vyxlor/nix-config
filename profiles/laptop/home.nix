{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  strixos = {
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
    };
    style = {
      theme.generateWithImage = ../../themes/background/cyber_city.jpg;
      targets.btop = true;
      desktop = {
        enable = true;
        cursor = {
          name = "BreezeX-RosePine-Linux";
          package = pkgs.rose-pine-cursor;
          size = 24;
        };
        cosmic = {
          alpha = 0.4;
          primaryAlpha = 0.6;
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
          theme = "hazy";
          style = true;
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
          bind = [
            ",XF86Favorites, exec, spotify"
            ",XF86HangupPhone, exec, playerctl next"
            ",XF86NotificationCenter, exec, playerctl previous"
            ",XF86PickupPhone, exec, playerctl play-pause"
          ];
          windowrule = [
            "tile on,match:class Aseprite"
          ];
          device = [
            {
              name = "compx-2.4g-wireless-receiver";
              sensitivity = -0.1;
            }
          ];
          debug = {
            full_cm_proto = true;
          };
        };
        apps = {
          launcher = "wofi";
          osd = "swayosd";
          wallpaper = "swww";
          notification = "swaync";
          statusbar = "strix-shell";
          filemanager = "cosmic";
          waybar = {
            brightness = true;
            battery = true;
            temperature = true;
            bluetooth = true;
            wakeLock = true;
          };
        };
        plugins.hyprexpo = true;
      };
    };
  };

  programs.strix-shell.config = {
    BarType = "horizontal";
    HorizontalBar = {
      Widgets = {
        Left = [
          "PopoverPower"
          "Clock"
          "Tray"
        ];
        Center = [
          "HyprlandWorkspace"
        ];
        Right = [
          "Inhibitor"
          "Network"
          "Battery"
        ];
      };
      PopoverPower.label = "";
      HyprlandWorkspace.preload = 5;
    };
  };

  home.packages = with pkgs; [
    git
    tea
    ffmpeg
    reaper
    musescore

    moonlight-qt
    (bottles.override {removeWarningPopup = true;})

    inkscape

    orca-slicer
    (freecad.overrideAttrs (final: prev: {
      pname = "freecad-dev";
      version = "weekly-2026.02.04";
      src = pkgs.fetchFromGitHub {
        owner = "FreeCAD";
        repo = "FreeCAD";
        tag = final.version;
        hash = "sha256-sbPUN1pAJfBNsnHxXWdXAIxBKKubJ17/InTB+9jC68g=";
        fetchSubmodules = true;
      };

      patches = [
        (fetchpatch {
          url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-unstable/pkgs/by-name/fr/freecad/0001-NIXOS-don-t-ignore-PYTHONPATH.patch";
          hash = "sha256-PTSowNsb7f981DvZMUzZyREngHh3l8qqrokYO7Q5YtY=";
        })
      ];
      postPatch = '''';
    }))

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
    fastfetch
    tldr
    wikiman

    blueberry
    qalculate-gtk
    loupe
    vlc
    onlyoffice-desktopeditors
    strix-theme-generator
    colorfull-papirus
    rose-pine-hyprcursor
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
    };
    associations.added = {
      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
    };
  };

  programs.zix = {
    enable = true;
    config.root_command = "sudo";
  };

  home.stateVersion = "25.11";
}
