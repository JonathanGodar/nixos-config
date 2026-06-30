{
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.nixos.homeManager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };

  flake.modules.homeManager.homeManager =
    { ... }:
    {
      programs.home-manager.enable = true;
      home.stateVersion = "24.05";
    };
}
