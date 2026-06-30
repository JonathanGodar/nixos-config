{ self, ... }:
{
  flake.modules.nixos.nix = {
    nix.settings = {
      builders-use-substitutes = true;
    };
  };
}
