{
  description = "Jonathans NixOs config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-9f41.url = "github:nixos/nixpkgs/9f4128e00b0ae8ec65918efeba59db998750ead6";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprcursor-phinger = {
      url = "github:jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      url = "github:Spencer-Sawyer/OpenTabletDriver/2b84e38477bd3a2e8790d96bdbf4bcaae8e49e80";
      flake = false;
    };

    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-9f41,
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
          inherit hostname;
          pkgs-9f41 = import nixpkgs-9f41 {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/${hostname}
          {
            networking.hostName = hostname;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit hostname;
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
  in rec {
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
      rpi4 = mkSystem {
        system = "aarch64-linux";
        hostname = "rpi4";
        extraModules = [nixos-hardware.nixosModules.raspberry-pi-4];
      };
    };

    # Copied from https://github.com/MatthewCroughan/raspberrypi-nixos-example/blob/master/flake.nix
    images = {
      rpi4 =
        (self.nixosConfigurations.rpi4.extendModules
          {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              # {
              # disabledModules =
              # }
            ];
          })
        .config
        .system
        .build
        .sdImage;
    };
  };
}
