{
  config,
  pkgs,
  lib,
  ...
}: let
  background = ../../themes/background/commingheremoreoftenlatly/jake-comingheremoreoftenlately.jpg;
  stripPrefix = inp: (builtins.substring 1 8 inp);
in {
  nixpkgs.config.allowUnfree = true;

  imports = [
    (import ./style/hyprlock.nix background)
    ./style/strix-shell.nix
  ];

  programs.matugen = {
    enable = true;
    wallpaper = background;
    source_color = "#a91a16";
    type = "scheme-tonal-spot";
    jsonFormat = "strip";
    variant = "dark";
    lightness_dark = -0.05;
    templates = {
      base16 = {
        input_path = "${./.}/themes/base16.in.yaml";
        output_path = "~/base16.yaml";
      };
      strix-shell = {
        input_path = "${./.}/themes/strix-shell.in.scss";
        output_path = "~/strix-shell.scss";
      };
    };
  };

  strixos = {
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
    };
    style = {
      theme = {
        scheme = "${config.programs.matugen.theme.files}/base16.yaml";
        polarity = "dark";
        image = background;
      };
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
        style = false;
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
            "hyprlock"
          ];
          bind = [
            ",XF86Favorites, exec, spotify"
            ",XF86HangupPhone, exec, playerctl next"
            ",XF86NotificationCenter, exec, playerctl previous"
            ",XF86PickupPhone, exec, playerctl play-pause"
            ",Print, exec, hyprshot -m region --clipboard-only"
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
          general = {
            border_size = 5;
            gaps_in = 5;
            gaps_out = 5;
            "col.active_border" =
              ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.primary.default.color
              + " "
              + ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.primary_container.default.color
              + " "
              + ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.secondary.default.color
              + " "
              + ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.secondary_container.default.color
              + " "
              + ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.tertiary.default.color
              + " "
              + ''0xff''
              + stripPrefix config.programs.matugen.theme.colors.tertiary_container.default.color
              + " 270deg";
            "col.inactive_border" =
              ''0xaa''
              + stripPrefix config.programs.matugen.theme.colors.background.default.color
              + " "
              + ''0xaa''
              + stripPrefix config.programs.matugen.theme.colors.surface.default.color
              + " "
              + ''0xaa''
              + stripPrefix config.programs.matugen.theme.colors.surface_container.default.color
              + " "
              + ''0xaa''
              + stripPrefix config.programs.matugen.theme.colors.shadow.default.color
              + " 270deg";
          };
          decoration = {
            rounding = 8;
            blur = {
              size = 5;
              passes = 2;
              contrast = 1.17;
              brightness =
                if config.stylix.polarity == "dark"
                then 0.8
                else 1.25;
            };
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
      version = "weekly-2026.02.11";
      src = pkgs.fetchFromGitHub {
        owner = "FreeCAD";
        repo = "FreeCAD";
        tag = final.version;
        hash = "sha256-sFMi793D1+1PQbBtQzfslS7UZ2Dob6+Z1bo7bUAVmFA=";
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
    hyprshutdown
    hyprshot
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
