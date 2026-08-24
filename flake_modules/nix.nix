{ self, ... }:
{
  flake.modules.nixos.nix = {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      builders-use-substitutes = true;
    };
  };
}
