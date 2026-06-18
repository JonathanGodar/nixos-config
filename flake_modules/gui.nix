{ self, ... }:
{
  flake.nixosModules.gui =
    { _ }:
    {
      programs.firefox.enable = true;
    };
}
