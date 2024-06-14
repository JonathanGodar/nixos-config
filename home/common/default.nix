{ config, pkgs, ...}:
{
	home.username = "jonathan";
	home.homeDirectory = "/home/jonathan";

	programs.starship = {
		enable = true;
	};

	home.stateVersion = "24.05";

	programs.home-manager.enable = true;

	home.packages = with pkgs; [
		cowsay
	];
}
