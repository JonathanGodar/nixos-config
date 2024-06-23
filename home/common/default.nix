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

	gtk.catppuccin.enable = true;
	programs.alacritty.catppuccin.enable = true;
	programs.bat.catppuccin.enable = true;
	programs.btop.catppuccin.enable = true;
	programs.fzf.catppuccin.enable = true;
	programs.git.delta.catppuccin.enable = true;
	programs.helix.catppuccin.enable = true;
	programs.lazygit.catppuccin.enable = true;
	programs.lazygit.enable = true;

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

		nvim-pkg
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
		bind-key '"' split-window -v -c "#{pane_current_path}"
		'';
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
	};

	programs.zoxide.enable = true;
}
