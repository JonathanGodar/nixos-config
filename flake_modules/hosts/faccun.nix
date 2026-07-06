{ inputs, self, ... }:
{
  flake = {
    # Innan kan byta
    # direnv
    # dusnt
    # comma
    nixosConfigurations.faccun = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.faccunConfig
      ];
    };

    modules = {
      nixos.faccunConfig =
        {
          config,
          pkgs,
          ...
        }:
        {
          imports = with self.modules.nixos; [
            workstation
            faccunHardware

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

      homeManager.faccun =
        { pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            workstation
          ];
          # with self.modules.homeManager; [
          # homeManager
        };
    };
  };
}
