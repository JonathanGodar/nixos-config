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

    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    tmuxSessionX = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
      flake = true;
    };

    lazyvim = {
      url = "github:JonathanGodar/LazyVim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    opentablet-ugee = {
      url = "github:Spencer-Sawyer/OpenTabletDriver/2b84e38477bd3a2e8790d96bdbf4bcaae8e49e80";
      flake = false;
    };

    rnote-export.url = "github:JonathanGodar/rnote_export";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-9f41,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      mkSystem =
        {
          hostname,
          system,
          extraModules ? [ ],
        }:
        (nixpkgs.lib.nixosSystem {
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
            ./nixos_modules
            ./hosts/${hostname}
            {
              networking.hostName = hostname;
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "rebuild_backup";
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
          ] ++ extraModules;
        });
    in
    rec {
      nixosConfigurations = {
        faccun = mkSystem rec {
          system = "x86_64-linux";
          hostname = "faccun";
          extraModules = [
            inputs.rnote-export.nixosModules.${system}.default
            (
              { pkgs, ... }:
              {
                services.rnote-export = {
                  enable = true;
                  inputDirectory = "/home/jonathan/kth";
                  user = "jonathan";
                  group = "users";
                  includeString = "*/föreläsningar/*.rnote";
                };

                services.nginx = {
                  enable = true;
                  additionalModules = [ pkgs.nginxModules.fancyindex ];

                  virtualHosts."192.168.1.83" = {
                    root = "/var/lib/rnote-export/";
                    locations."/" = {
                      extraConfig = ''
                        fancyindex on;
                      '';
                    };
                  };
                };
              }
            )
          ];
        };
        wax9 = mkSystem rec {
          system = "x86_64-linux";
          hostname = "wax9";
          extraModules = [
            nixos-hardware.nixosModules.huawei-machc-wa
            inputs.rnote-export.nixosModules.${system}.default
            {
              services.rnote-export = {
                enable = true;
                user = "jonathan";
                group = "users";
                inputDirectory = "/home/jonathan/kth/pde/";
                includeString = "föreläsningar/F*.rnote";
              };
            }
          ];
        };
        rpi4 = mkSystem rec {
          system = "aarch64-linux";
          hostname = "rpi4";
          extraModules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            inputs.rnote-export.nixosModules.${system}.default
          ];
        };
      };

      # Copied from https://github.com/MatthewCroughan/raspberrypi-nixos-example/blob/master/flake.nix
      images = {
        rpi4 =
          (self.nixosConfigurations.rpi4.extendModules {
            modules = [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              {
                disabledModules = [
                  nixos-hardware.nixosModules.raspberry-pi-4
                ];
              }
              {
                sdImage.compressImage = false;

                # Let the sd-image thing take care of the file system paths
                rpi4_fs.enable = false;
              }
            ];
          }).config.system.build.sdImage;
      };
    };
}
