{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    (./. + ("/" + userSettings.shell) + ".nix")
  ];

  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "    ";
        constants = [
          "─────────────────"
        ];
        key = {
          type = "icon";
          paddingLeft = 2;
        };
      };
      modules = [
        {
          type = "custom";
          format = "┌{$1} {#1}Hardware Information{#} {$1}┐";
        }
        "host"
        "cpu"
        "gpu"
        "disk"
        "memory"
        "swap"
        "display"
        "brightness"
        "battery"
        "poweradapter"
        "bluetooth"
        "sound"
        "gamepad"
        {
          type = "custom";
          format = "├{$1} {#1}Software Information{#} {$1}┤";
        }
        {
          type = "title";
          keyIcon = "";
          key = "Title";
          format = "{user-name}@{host-name}";
        }
        "os"
        "kernel"
        "lm"
        "de"
        "wm"
        "shell"
        "terminal"
        "terminalfont"
        "theme"
        "icons"
        "wallpaper"
        "packages"
        "uptime"
        "media"
        {
          type = "localip";
          compact = true;
        }
        {
          type = "publicip";
          timeout = 1000;
        }
        {
          type = "wifi";
          format = "{ssid}";
        }
        "locale"
        {
          type = "custom";
          format = "└{$1}──────────────────────{$1}┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    gawk
    fastfetch
    gnugrep
    ripgrep
    gnused
    htop
    unzip
    gzip
    file
    gnutar
    axel
  ];
}
