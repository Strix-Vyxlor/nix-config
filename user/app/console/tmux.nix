{ pkgs, userSettings, config, ... }:
let
  shell_pkg = pkgs."${userSettings.shell}";
in {
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux = {
    enable = true;
    
    shell = "${shell_pkg}/bin/${userSettings.shell}";
    newSession = true;
   mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      tmux-nova
    ];

    extraConfig = ''
     set-option -ga terminal-overrides ",xterm*:Tc"
     set -g default-terminal "alacritty" 

     unbind C-b
     set -g prefix C-Space
     bind C-Space send-prefix

     set -g base-index 1
     setw -g pane-base-index 1
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

      bind -n M-Down previous-window
      bind -n M-Up next-window

      unbind '"'
      unbind %
      bind v split-window -v -c "#{pane_current_path}"
      bind h split-window -h -c "#{pane_current_path}"

      set -g @nova-nerdfonts true
      set -g @nova-nerdfonts-left 
      set -g @nova-nerdfonts-right 

      set -g @nova-pane-active-border-style "#${config.lib.stylix.colors.base02}"
      set -g @nova-pane-border-style "#${config.lib.stylix.colors.base01}"
      set -g @nova-status-style-bg "#${config.lib.stylix.colors.base00}"
      set -g @nova-status-style-fg "#${config.lib.stylix.colors.base05}"
      set -g @nova-status-style-active-bg "#${config.lib.stylix.colors.base0D}"
      set -g @nova-status-style-active-fg "#${config.lib.stylix.colors.base05}"
      set -g @nova-status-style-double-bg "#${config.lib.stylix.colors.base05}"

      set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

      set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
      set -g @nova-segment-mode-colors "#${config.lib.stylix.colors.base0C} #${config.lib.stylix.colors.base05}"

      set -g @nova-segment-whoami "#(whoami)@#h"
      set -g @nova-segment-whoami-colors "#${config.lib.stylix.colors.base0C} #${config.lib.stylix.colors.base05}"

      set -g @nova-rows 0
      set -g @nova-segments-0-left "mode"
      set -g @nova-segments-0-right "whoami"
    '';
  };
}
