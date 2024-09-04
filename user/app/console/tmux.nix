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
    baseIndex = 1;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme '#${config.lib.stylix.colors.base0D}'
          set -g @tmux_power_date_icon " "
          set -g @tmux_power_time_icon ''
          set -g @tmux_power_user_icon ''
          set -g @tmux_power_session_icon " "
          set -g @tmux_power_show_upload_speed    false
          set -g @tmux_power_show_download_speed  false
          set -g @tmux_power_show_web_reachable   false
          set -g @tmux_power_right_arrow_icon     ''
          set -g @tmux_power_left_arrow_icon      ''
          set -g @tmux_power_upload_speed_icon    '󰕒'
          set -g @tmux_power_download_speed_icon  '󰇚'
          set -g @tmux_power_prefix_highlight_pos 'R' 
        '';
      }
      {
        plugin = yank;
        extraConfig = ''
          unbind c
          bind c copy-mode

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];

    extraConfig = ''
     set-option -ga terminal-overrides ",xterm*:Tc"
     set -g default-terminal "alacritty" 

     unbind C-b
     set -g prefix C-Space
     bind C-Space send-prefix 


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

      bind -n C-PageDown previous-window
      bind -n C-PageUp next-window

      unbind '"'
      unbind %
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}" 
      
      unbind n
      unbind p
      bind n new-window -c "#{pane_current_path}" 

      unbind q
      bind q confirm-before -p "kill tmux? (y/n)" "kill-session"

      bind R command-prompt -p "New session name: " "rename-session '%1'"
      bind r command-prompt -p "New window name: " "rename-window '%1'"
    '';
  };
}
