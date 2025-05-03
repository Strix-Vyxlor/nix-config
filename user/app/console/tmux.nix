{
  pkgs,
  userSettings,
  config,
  ...
}: let
  shell_pkg =
    if (userSettings.shell == "nu")
    then pkgs.nushell
    else pkgs."${userSettings.shell}";
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

       # tmux power
       run-shell /home/${userSettings.username}/.config/tmux/plugins/tmux-power.tmux
    '';
  };

  home.file.".config/tmux/plugins/tmux-power.tmux" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      #===============================================================================
        #   Author: Wenxuan
        #    Email: wenxuangm@gmail.com
        #  Created: 2018-04-05 17:37
        #===============================================================================

        # $1: option
        # $2: default value
        tmux_get() {
            local value="$(tmux show -gqv "$1")"
            [ -n "$value" ] && echo "$value" || echo "$2"
        }

        # $1: option
        # $2: value
        tmux_set() {
            tmux set-option -gq "$1" "$2"
        }

        # Options
        rarrow=$(tmux_get '@tmux_power_right_arrow_icon' '')
        larrow=$(tmux_get '@tmux_power_left_arrow_icon' '')
        upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '󰕒')
        download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '󰇚')
        session_icon="$(tmux_get '@tmux_power_session_icon' ' ')"
        user_icon="$(tmux_get '@tmux_power_user_icon' '')"
        time_icon="$(tmux_get '@tmux_power_time_icon' '')"
        date_icon="$(tmux_get '@tmux_power_date_icon' ' ')"
        show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
        show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
        show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
        prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos 'R')
        time_format=$(tmux_get @tmux_power_time_format '%T')
        date_format=$(tmux_get @tmux_power_date_format '%F')
        # short for Theme-Colour
        TC=#${config.lib.stylix.colors.base0D}

        G01=#${config.lib.stylix.colors.base01} #232
        G02=#${config.lib.stylix.colors.base01} #233
        G03=#${config.lib.stylix.colors.base01} #234
        G04=#${config.lib.stylix.colors.base00} #235
        G05=#${config.lib.stylix.colors.base00} #236
        G06=#${config.lib.stylix.colors.base03} #237
        G07=#${config.lib.stylix.colors.base03} #238
        G08=#${config.lib.stylix.colors.base03} #239
        G09=#${config.lib.stylix.colors.base03} #240
        G10=#${config.lib.stylix.colors.base03} #241
        G11=#${config.lib.stylix.colors.base03} #242
        G12=#${config.lib.stylix.colors.base03} #243

        FG="$G10"
        BG="$G04"

        # Status options
        tmux_set status-interval 1
        tmux_set status on

        # Basic status bar colors
        tmux_set status-fg "$FG"
        tmux_set status-bg "$BG"
        tmux_set status-attr none

        # tmux-prefix-highlight
        tmux_set @prefix_highlight_fg "$BG"
        tmux_set @prefix_highlight_bg "$FG"
        tmux_set @prefix_highlight_show_copy_mode 'on'
        tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
        tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$larrow#[bg=$TC]#[fg=$BG]"
        tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$rarrow"

        #     
        # Left side of status bar
        tmux_set status-left-bg "$G04"
        tmux_set status-left-fg "$G12"
        tmux_set status-left-length 150
        user=$(whoami)
        LS="#[fg=$G04,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$G06,nobold]$rarrow#[fg=$TC,bg=$G06] $session_icon #S "
        if "$show_upload_speed"; then
            LS="$LS#[fg=$G06,bg=$G05]$rarrow#[fg=$TC,bg=$G05] $upload_speed_icon #{upload_speed} #[fg=$G05,bg=$BG]$rarrow"
        else
            LS="$LS#[fg=$G06,bg=$BG]$rarrow"
        fi
        if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
            LS="$LS#{prefix_highlight}"
        fi
        tmux_set status-left "$LS"

        # Right side of status bar
        tmux_set status-right-bg "$BG"
        tmux_set status-right-fg "$G12"
        tmux_set status-right-length 150
        RS="#[fg=$G06]$larrow#[fg=$TC,bg=$G06] $time_icon $time_format #[fg=$TC,bg=$G06]$larrow#[fg=$G04,bg=$TC] $date_icon $date_format "
        if "$show_download_speed"; then
            RS="#[fg=$G05,bg=$BG]$larrow#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} $RS"
        fi
        if "$show_web_reachable"; then
            RS=" #{web_reachable_status} $RS"
        fi
        if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
            RS="#{prefix_highlight}$RS"
        fi
        tmux_set status-right "$RS"

        # Window status format
        tmux_set window-status-format         "#[fg=$BG,bg=$G06]$rarrow#[fg=$TC,bg=$G06] #I:#W#F #[fg=$G06,bg=$BG]$rarrow"
        tmux_set window-status-current-format "#[fg=$BG,bg=$TC]$rarrow#[fg=$BG,bg=$TC,bold] #I:#W#F #[fg=$TC,bg=$BG,nobold]$rarrow"

        # Window status style
        tmux_set window-status-style          "fg=$TC,bg=$BG,none"
        tmux_set window-status-last-style     "fg=$TC,bg=$BG,bold"
        tmux_set window-status-activity-style "fg=$TC,bg=$BG,bold"

        # Window separator
        tmux_set window-status-separator ""

        # Pane border
        tmux_set pane-border-style "fg=$G07,bg=default"

        # Active pane border
        tmux_set pane-active-border-style "fg=$TC,bg=default"

        # Pane number indicator
        tmux_set display-panes-colour "$G07"
        tmux_set display-panes-active-colour "$TC"

        # Clock mode
        tmux_set clock-mode-colour "$TC"
        tmux_set clock-mode-style 24

        # Message
        tmux_set message-style "fg=$TC,bg=$BG"

        # Command message
        tmux_set message-command-style "fg=$TC,bg=$BG"

        # Copy mode highlight
        tmux_set mode-style "bg=$TC,fg=$FG"
    '';
  };
}
