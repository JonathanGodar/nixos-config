{ nixpkgs, self, ... }:
{
  flake = {
    nixosConfigurations.faccun = [ self.nixosModules.faccunConfig ];
    homeConfigurations.faccun = [ self.nixosModules.faccunConfig ];

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
          faccunHardware
          steam
        ];

        networking.hostName = "faccun";
        networking.hostId = "354736d9";
      };
  };
}
