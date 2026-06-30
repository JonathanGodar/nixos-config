{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.faccun = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.faccunConfig
      ];
    };

    modules.nixos.faccunConfig =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = with self.modules.nixos; [
          base
          gui
          hyprland
          faccunHardware
          steam

          # For home-manager
          homeManager # Activates home-manager options
          {
            home-manager.users.jonathan.imports = [
              self.modules.homeManager.faccun # Bootstraps the first home-manager module for the system
            ];
          }
        ];

        networking.hostName = "faccun";
        networking.hostId = "354736d9";
      };
    modules.homeManager.faccun =
      { pkgs, ... }:
      {
        imports = with self.modules.homeManager; [
          homeManager
        ];
      };
  };
}
