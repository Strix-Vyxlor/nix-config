{
  pkgs,
  lib,
  ...
}: let
  steamos-session-select = pkgs.writeShellScriptBin "steamos-session-select" ''
    #!${pkgs.bash}/bin/bash
    steam -shutdown
  '';
  jupiter-dock-updater = pkgs.writeTextFile {
    name = "jupiter-dock-updater";
    text = ''

    '';
    executable = true;
    destination = "/bin/steamos-polkit-helpers/jupiter-dock-updater";
  };
  steamos-select-branch = pkgs.writeShellScriptBin "steamos-select-branch" ''
    #!/bin/sh
    >&2 echo "stub called with: $*"
    case "$1" in
        "-c")
            # What is our current branch? Pretend to be main
            echo "main"
            ;;
        "-l")
            # What branches are available? Pretend to only have main
            echo "main"
            ;;
        *)
            # Switch branch, just do nothing
            ;;
    esac
  '';
in {
  programs.steam = {
    extraPackages =
      [
        steamos-session-select
        jupiter-dock-updater
        steamos-select-branch
      ]
      ++ (with pkgs; [
        brightnessctl
      ]);
    gamescopeSession = {
      enable = true;
      env = {
        # mangohud
        STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
        STEAM_USE_MANGOAPP = "1";
        STEAM_USE_DYNAMIC_VRS = "1";
        STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
        STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND = "1";

        # misc
        STEAM_ENABLE_VOLUME_HANDLER = "1";
        STEAM_DISABLE_AUDIO_DEVICE_SWITCHING = "1";
        STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
        SRT_URLOPEN_PREFER_STEAM = "1";

        STEAM_GAMESCOPE_NIS_SUPPORTED = "1";

        QT_IM_MODULE = "steam";
        GTK_IM_MODULE = "Steam";

        XKB_DEFAULT_LAYOUT = "be";
      };
      args = [
        "--mangoapp"
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
