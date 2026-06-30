{ self, ... }:
{
  flake.nixosModules.gui =
    { _ }:
    {
      programs.firefox.enable = true;
    };

  flake.homeModules.gui =
    { _ }:
    {

    };
}
