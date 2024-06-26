{ config, pkgs, lib, catppuccin, inputs, ...}:
{
	home.username = "jonathan";
	home.homeDirectory = "/home/jonathan";
	
	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};

	home.stateVersion = "24.05";

	programs.home-manager.enable = true;

	programs.alacritty = {
		enable  = true;
		settings = {
			window.decorations = "None";
			shell.program = "tmux";
		};
	};
	programs.bat.enable  = true;

  catppuccin.enable = true;

	gtk.catppuccin.enable = true;
	programs.alacritty.catppuccin.enable = true;
	programs.bat.catppuccin.enable = true;
	programs.btop.catppuccin.enable = true;
	programs.fzf.catppuccin.enable = true;
	programs.git.delta.catppuccin.enable = true;
	programs.helix.catppuccin.enable = true;
	programs.lazygit.catppuccin.enable = true;
	programs.lazygit.enable = true;

	programs.waybar.catppuccin.enable = true;
	programs.waybar = {
    enable = true;
    settings = {
      mainBar =  {
        modules-left = [ "hyprland/workspaces" "hyprland/mode" "wlr/taskbar" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "mpd" "temperature" ];
      };
    };
		#     "hyprland/workspaces": {
		#       "disable-scroll": true,
		# "format": "{name} {icon}",
		# "format-icons": {
		# 	"active": " ",
		# 	"default": " "
		# },
		#       "persistent_workspaces": {
		#           "1": [],
		#           "2": [],
		#           "3": [],
		#           "4": [],
		#       },
		#   },
  };

	# programs.neovim.enable = true;

	programs.starship.catppuccin.enable = true;
	programs.tmux.catppuccin.enable = true;
	programs.zsh.syntaxHighlighting.catppuccin.enable = true;
	qt.style.catppuccin.enable = true;

	home.packages = with pkgs; [
		go

		dust # Analyze disk usage
		tldr # "man" in short form
		gh #Github cli tool

		fd
		ripgrep

		discord
		vesktop
		mattermost-desktop
    
    tofi

    pavucontrol # Needed for waybar

		nvim-pkg
    
    # lxqt.lxqt-policykit
    kdePackages.polkit-kde-agent-1
	];


	programs.tmux = {
		enable = true;

		shortcut = "Space";
		plugins = with pkgs.tmuxPlugins; [ sensible vim-tmux-navigator inputs.tmuxSessionX.packages."x86_64-linux".default ];

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
		# Already enabled above when setting catppuccin
		# syntaxHighlighting.enable = true;

		history = {
			size=100000;
		};

		shellAliases = {
			lsa = "ls -la";
			lz = "lazygit";
			cd = "z";
			rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
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

		initExtra = 
		''
# Case insensitive completion 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no 

# Supposed to make the <Ctrl-P> and N shortcuts "prefix sensitive"
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

FD_OPTIONS="--hidden --no-ignore . --exclude node_modules --exclude target --exclude __pycache__ --exclude .git -L"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
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

    extraConfig = {
      diff.tool = "nvimdiffview";
      difftool.nvimdiffview.cmd = "nvim -c 'DiffviewOpen' -- $LOCAL $REMOTE";
    }; 
	};

	programs.zoxide.enable = true;

  wayland.windowManager.hyprland.catppuccin.enable = true;
  wayland.windowManager.hyprland.enable = true;


  services.dunst = {
    enable = true;
    catppuccin.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "waybar"
      "dunst"
      "dbus-update-activation-environment --systemd --all"
      "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
      "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
      # "lxqt.lxqt-policykit"
    ];

    input = {
      kb_layout = "se";
      kb_variant = "nodeadkeys";
    };

    "$mod" = "SUPER";
    "$MAIN_MONITOR" = "DP-2";
    "$OTHER_MONITOR" = "DP-1";

    monitor = [
      "$OTHER_MONITOR, 1920x1080@144, 0x0, 1"
      "$MAIN_MONITOR, 1920x1080@144, 1920x0, 1"
      "Unknown-1, disable"
    ];

    workspace = [
      "8, monitor:DP-1,default:true"
      "9, monitor:DP-1"
      "10, monitor:DP-1"
      # "2, border:false"
      # "r[1-7], monitor:$MAIN_MONITOR"
      # "r[8-10], monitor:$OTHER_MONITOR"
    ];


    bind =
      [
        "SUPER, B, exec, firefox"
        "$mod, Return, exec, alacritty"
        "SUPER_SHIFT, c, killactive"

        ", Print, exec, grimblast copy area"

        # HJKL to switch active window
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        # HJKL to move active window position
        "SUPER_SHIFT, h, swapwindow, l"
        "SUPER_SHIFT, j, swapwindow, d"
        "SUPER_SHIFT, k, swapwindow, u"
        "SUPER_SHIFT, l, swapwindow, r"

        "SUPER, f, fullscreen, 0"
        "SUPER, m, fullscreen, 1"

      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };
}
