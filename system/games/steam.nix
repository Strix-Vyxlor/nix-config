{pkgs, ...}: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    gamescopeSession = {
      enable = true;
      env = {
        # mangohud
        STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
        STEAM_USE_MANGOAPP = "1";
        STEAM_USE_DYNAMIC_VRS = "1";
        STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
        # misc
        STEAM_ENABLE_VOLUME_HANDLER = "1";
        STEAM_DISABLE_AUDIO_DEVICE_SWITCHING = "1";
        STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
      };
    };
  };
}
