{
  pkgs,
  userSettings,
  ...
}: let
  steamos-session-select = pkgs.writeShellScriptBin "steamos-session-select" ''
    #!${pkgs.bash}/bin/bash
    steam -shutdown
  '';
in {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    #extest.enable = true;
    extraPackages = [
      steamos-session-select

      pkgs.mangohud
    ];
    gamescopeSession = {
      enable = true;
      env = {
        # mangohud
        STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
        STEAM_USE_MANGOAPP = "1";
        STEAM_USE_DYNAMIC_VRS = "1";
        STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
        STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND = "1";

        #SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
        # misc
        STEAM_ENABLE_VOLUME_HANDLER = "1";
        STEAM_DISABLE_AUDIO_DEVICE_SWITCHING = "1";
        STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
        SRT_URLOPEN_PREFER_STEAM = "1";
        #STEAM_MULTIPLE_XWAYLANDS = "1";
        #STEAM_GAMESCOPE_DYNAMIC_FPSLIMITER = "1";
        #STEAM_GAMESCOPE_HAS_TEARING_SUPPORT = "1";
        STEAM_GAMESCOPE_NIS_SUPPORTED = "1";
        #STEAM_GAMESCOPE_TEARING_SUPPORTED = "1";
        QT_IM_MODULE = "steam";
        GTK_IM_MODULE = "Steam";

        XKB_DEFAULT_LAYOUT = "be";
      };
      args = [
        "--mangoapp"
        #"--steam"
        #"--expose-wayland"
      ];
      steamArgs = [
        "-steamos3"
        "-steampal"
        "-steamdeck"
        "-gamepadui"
        #"-tenfoot"
        "-pipewire-dmabuf"
      ];
    };
  };
}
