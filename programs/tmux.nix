{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    aggressiveResize = true;
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    clock24 = true;
    terminal = "screen-256color";
    historyLimit = 50000;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.online-status;
        extraConfig = ''
          set -g status-right "Online: #{online_status} | %a %h-%d %H:%M "
          set -g @online_icon "ok"
          set -g @offline_icon "offline!"
          set -g @route_to_ping "1.1.1.1"
        '';
      }
      tmuxPlugins.pain-control
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    extraConfig = ''
      set-option -g mouse on
      bind-key a send-prefix
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      set -g status-position bottom
      set-option -g set-titles on
      set-optiong -g title-string "Tmux #{online_status} #{session_name} > #{pane_title} | #h"
    '';
  };
}
