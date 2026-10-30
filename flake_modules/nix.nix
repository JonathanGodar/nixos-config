{ self, ... }:
{
  flake.modules.nixos.nix = { config, ... }: {
    nixpkgs.config.allowUnfree = true;

    nix = {
      registry = {
        jonis.to = {
          type = "path";
          path = "${config.systemOptions.flakePath}";
        };
      };

      settings = {
        builders-use-substitutes = true;
      };
    };
  };
}
