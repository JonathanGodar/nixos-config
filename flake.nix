{
  description = "Jonathans NixOs config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
    nixos-hardware,
    ...
  } @ inputs: let
    mkSystem = {
      hostname,
      system,
      extraModules ? [],
    }: (
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/${hostname}

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.jonathan = {
              imports = [
                inputs.catppuccin.homeManagerModules.catppuccin
                ./home_modules
                ./home/${hostname}
              ];
            };
          }
        ];
      }
    );
  in {
    nixosConfigurations = {
      faccun = mkSystem {
        system = "x86_64-linux";
        hostname = "faccun";
      };
      wax9 = mkSystem {
        system = "x86_64-linux";
        hostname = "wax9";
        extraModules = [nixos-hardware.nixosModules.huawei-machc-wa];
      };
      # rpi4 = mkSystem {
      #   system = "aarch64-linux";
      #   hostname = "rpi4";
      # };
    };
  };
}
