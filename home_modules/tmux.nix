{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  options.preconf.tmux.enable = lib.mkEnableOption "Enable tmux";
  config = lib.mkIf config.preconf.tmux.enable {
    programs.tmux = {
      enable = true;

      shortcut = "Space";
      plugins = with pkgs.tmuxPlugins; [sensible vim-tmux-navigator inputs.tmuxSessionX.packages."${pkgs.system}".default];

      terminal = "screen-256color";
      mouse = true;

      extraConfig = ''
        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Resize windows with vim Motions 
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5


        # Start lazygit instance
        bind g run-shell "tmux neww -c '#{pane_current_path}' lazygit"

        # Partially restore clear screen
        bind C-l send-keys 'C-l'

        # Force true colors
        set-option -ga terminal-overrides ",*:Tc"

        # Make <Leader> r reload the config
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf 
        set-option -g status-position top

        # Make the numbering of windows and panes more sane
        set -g base-index 1
        set -g renumber-windows 1
        setw -g pane-base-index 1

        # New windows start in the same directory as the current window
        bind-key c new-window -c "#{pane_current_path}"

        # New panes split horizontally in the same directory as the current pane
        bind-key % split-window -h -c "#{pane_current_path}"

        # New panes split vertically in the same directory as the current pane
        bind-key '"' split-window -v -c "#{pane_current_path}" '';
    };
  };
}
