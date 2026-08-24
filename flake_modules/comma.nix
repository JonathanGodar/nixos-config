{ inputs, ... }:
{
  # flake.modules.nixos.comma = {
  #
  #
  # };

  flake.modules.homeManager.comma =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.default
      ];

      programs = {
        nix-index = {
          enable = true;
          package =
            inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;
        };
        nix-index-database.comma.enable = true;
      };
    };
}
