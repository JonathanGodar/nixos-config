{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.faccun = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.faccunConfig
      ];
    };

    nixosModules.faccunConfig =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = with self.nixosModules; [
          base
          gui
          hyprland
          faccunHardware
          steam
        ];

        networking.hostName = "faccun";
        networking.hostId = "354736d9";
      };
  };
}
