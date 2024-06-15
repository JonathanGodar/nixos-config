{ config, pkgs, ...}:
{
	home.username = "jonathan";
	home.homeDirectory = "/home/jonathan";

	programs.starship = {
		enable = true;
		enableZshIntegration = true;
	};

	home.stateVersion = "24.05";

	programs.home-manager.enable = true;

	home.packages = with pkgs; [
		alacritty
		go

		dust # Analyze disk usage
		tldr # "man" in short form
		lazygit
	];


	programs.zsh = {
		enable = true;
		enableCompletion = true;

		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			lsa = "ls -la";
			lz = "lazygit";
			cd = "z";
			rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
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
