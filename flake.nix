{
  description = "Jonathans NixOs config";

  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	catppuccin.url = "github:catppuccin/nix";

	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	tmuxSessionX = {
		url = "github:omerxx/tmux-sessionx";
		inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ...}@inputs: {
  	nixosConfigurations.faccun = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			catppuccin.nixosModules.catppuccin
			./hosts/faccun

			home-manager.nixosModules.home-manager {
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.extraSpecialArgs = { inherit inputs; };



				home-manager.users.jonathan = {
					imports = [
						./home/common
						catppuccin.homeManagerModules.catppuccin
					];
				};
			}
		];
	};
  };
}
