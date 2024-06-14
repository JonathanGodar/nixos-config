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
		cowsay
	];

	programs.zsh = {
		enable = true;
		shellAliases = {
			ll = "ls -la";
		};

		plugins = [
			{
				# https://discourse.nixos.org/t/zsh-users-how-do-you-manage-plugins/9199/8
				name = "zsh-vi-mode";
				src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
			}
		];
	};

	programs.git = {
		enable = true;
		userName = "Jonathan Niklasson Godar";
		userEmail = "jonathan.godar@hotmail.com";
	};
}
