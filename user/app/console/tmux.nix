{ pkgs, userSettings, ... }:
let
  shell_pkg = pkgs."${userSettings.shell}";
in {
  home.packages = with pkgs; [
    tmux
  ];

  stylix.targets.tmux.enable = true;

  programs.tmux = {
    enable = true;
    
    shell = "${shell_pkg}/bin/${userSettings.shell}";
    newSession = true;
   mouse = true;

    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];

    extraConfig = ''
     set-option -ga terminal-overrides ",xterm*:Tc"
     set -g default-terminal "alacritty"

     set -s extended-keys on
     set -as terminal-features 'xterm*:extkeys'

     unbind C-b
     set -g prefix C-Space
     bind C-Space send-prefix

     set -g base-index 1
     set -g pane-base-index 1
     set-window-option -g pane-base-index 1
     set-option -g renumber-windows on

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-Left'  'select-pane -L'
      bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-Down'  'select-pane -D'
      bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-Up'  'select-pane -U'
      bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-Right'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-Left' select-pane -L
      bind-key -T copy-mode-vi 'C-Down' select-pane -D
      bind-key -T copy-mode-vi 'C-Up' select-pane -U
      bind-key -T copy-mode-vi 'C-Right' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind -n M-N previous-window
      bind -n M-E next-window
    '';
  };
}
