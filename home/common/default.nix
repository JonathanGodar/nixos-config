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
	];

	programs.fzf = {
		enable = true;
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;

		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			lsa = "ls -la";
			cd = "z";
			rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
		};

		plugins = [
			{
				# https://discourse.nixos.org/t/zsh-users-how-do-you-manage-plugins/9199/8
				name = "zsh-vi-mode";
				src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
			}
		];

		initExtra = 
		''
		# Case insensitive completion 
		zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

		# Supposed to make the <Ctrl-P> and N shortcuts "prefix sensitive"
		# bindkey '^p' history-search-backward
		# bindkey '^n' history-search-forward
		'';

	};

	programs.git = {
		enable = true;
		userName = "Jonathan Niklasson Godar";
		userEmail = "jonathan.godar@hotmail.com";
	};

	programs.zoxide.enable = true;
}
