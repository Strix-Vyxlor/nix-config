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
      theme.generateWithImage = ../../themes/background/starry-night.jpg;
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
            "tile,class:Aseprite"
          ];
          device = [
            {
              name = "compx-2.4g-wireless-receiver";
              sensitivity = -0.1;
            }
          ];
        };
        apps = {
          launcher = "wofi";
          osd = "swayosd";
          notification = "swaync";
          statusbar = "waybar-alt";
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

    moonlight-qt
    (bottles.override {removeWarningPopup = true;})

    # gamedev
    godot
    gdtoolkit_4
    inkscape
    android-tools
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.emulator
    androidenv.androidPkgs.ndk-bundle
    jdk17
    cmake

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
    qalculate-gtk
    loupe
    vlc
    onlyoffice-desktopeditors
    strix-theme-generator
    colorfull-papirus
    rose-pine-hyprcursor
  ];

  nixpkgs.config.android_sdk.accept_license = true;
  home.file.".local/share/godot/nix.json".text = builtins.toJSON (with pkgs; {
    export_templates = "${godot-export-templates-bin}/share/godot/export_templates/4.4.1.stable/";
    android-sdk = "${androidenv.androidPkgs.androidsdk}/libexec/android-sdk/";
    openjdk = jdk17;
  });

  xdg.mimeApps = {
    defaultApplications = {
      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
    };
    associations.added = {
      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
    };
  };

  programs.zix = {
    enable = true;
    config.root_command = "sudo";
  };

  home.stateVersion = "25.05";
}
