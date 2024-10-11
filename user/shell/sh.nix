{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    (./. + ("/" + userSettings.shell) + ".nix")
  ];
  # default system prompt
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      lla = "ls -la";
      neofetch = "fastfetch";
    };
    bashrcExtra = ''
      PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
      PS1='\[\e[31m\]\u\[\e[0m\]@\[\e[31m\]\h\[\e[33m\] (''${PS1_CMD1})\[\e[0m\]>\[\e[97m\] \[\e[37m\]\w\n\[\e[33m\]$?\[\e[36;1m\]>\[\e[0;97m\] \[\e[0m\]'
    '';
  };

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
  ];
}
