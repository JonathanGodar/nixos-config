{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [
    ./../wayland
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin.enable = true;

  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      direnv.disabled = false;
    };
  };

  services.syncthing.enable = true;
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "None";
      shell.program = "tmux";
      font.normal = {
        family = "JetBrains Mono Nerd Font";
        style = "Medium";
      };
      font.bold = {
        family = "JetBrains Mono Nerd Font";
        style = "Bold";
      };
      font.italic = {
        family = "JetBrains Mono Nerd Font";
        style = "MediumItalic";
      };
      font.bold_italic = {
        family = "JetBrains Mono Nerd Font";
        style = "BoldItalic";
      };
    };
  };

  programs.bat.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-left = ["hyprland/workspaces" "hyprland/mode" "wlr/taskbar"];
        modules-center = ["hyprland/window"];
        modules-right = ["mpd" "bluetooth" "tray" "network" "wireplumber"];
      };
    };
  };

  qt = {
    enable = true;

    # Required to use catppuccin style
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  home.packages = with pkgs; [
    killall

    go
    kondo # For removing unneeded files from software projects

    nh # Nix helper, provides nice diff when updating system

    prismlauncher
    openjdk

    cargo
    rustc

    inputs.nixvim.packages.${system}.default

    dust # Analyze disk usage
    tldr # "man" in short form
    gh #Github cli tool

    fd
    jq
    ripgrep
    fuzzel

    # Needed to make the desktopEntries
    xdg-utils

    cinnamon.nemo
    navigateOpenWindows

    eza

    chromium
    webcord
    vesktop
    mattermost-desktop

    rnote
    sioyek

    grim
    slurp
    tesseract
    wl-clipboard
    cliphist

    tofi

    pavucontrol # Needed for waybar

    # Old neovim config
    # nvim-pkg
    gimp

    # lxqt.lxqt-policykit
    kdePackages.polkit-kde-agent-1
  ];

  programs.lazygit.enable = true;

  xdg.desktopEntries = {
    ocrCopy = let
      copy-script = pkgs.writeShellApplication {
        name = "ocrcopy";
        runtimeInputs = with pkgs; [grim slurp tesseract wl-clipboard];
        text = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
      };
    in {
      name = "OCR copy screen area";
      exec = "${lib.getExe copy-script}";
    };
  };
  programs.tmux = {
    enable = true;

    shortcut = "Space";
    plugins = with pkgs.tmuxPlugins; [sensible vim-tmux-navigator inputs.tmuxSessionX.packages."x86_64-linux".default];

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;

    history = {
      size = 100000;
    };

    shellAliases = {
      lsa = "eza -F always --icons auto -la";
      lz = "lazygit";
      cd = "z";
      ls = "eza";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
      rebld = "nh os switch -a ~/nixos";
      q = "exit";

      cat = "bat";
    };

    plugins = [
      {
        # https://discourse.nixos.org/t/zsh-users-how-do-you-manage-plugins/9199/8
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    initExtraFirst = ''
      # Make it so that zsh-vi-mode does not override any later keybinding configurations
      ZVM_INIT_MODE=sourcing
    '';

    initExtra = ''
      # Case insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu no

      # Supposed to make the <Ctrl-P> and N shortcuts "prefix sensitive"
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      FD_OPTIONS="--hidden --no-ignore . --exclude node_modules --exclude target --exclude __pycache__ --exclude .git -L"
      export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
      export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
      export MANPAGER='nvim +Man!'
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Jonathan Niklasson Godar";
    userEmail = "jonathan.godar@hotmail.com";

    difftastic.enable = true;
    extraConfig = {
      pull.rebase = false;
    };

    # extraConfig = {
    #   diff.tool = "nvimdiff";
    #   difftool.prompt = false;
    #   difftool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\""; # "nvim -c 'DiffviewOpen' -- $LOCAL $REMOTE";
    # };
  };

  programs.zoxide.enable = true;
}
