{ self, ... }:
{
  flake.nixosModules.nix = {
    nix.settings = {
      builders-use-substitutes = true;
    };
  };
}
