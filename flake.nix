{
  description = "Jonathans NixOs config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";

    catppuccin-wallpaper-repo = {
      url = "github:zhichaoh/catppuccin-wallpapers";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmuxSessionX = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:JonathanGodar/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opentablet-ugee = {
      url = "github:Spencer-Sawyer/OpenTabletDriver/master";
      flake = false;
    };

    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    # mynvim,
    ...
  } @ inputs: {
    nixosConfigurations.faccun = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        inherit system;
        inherit inputs;
      };

      modules = [
        ./hosts/faccun
        ./binarycaches.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit system;
          };

          home-manager.users.jonathan = {
            imports = [
              ./home/faccun
            ];
          };
        }
      ];
    };
  };
}
