{ self, ... }:
{
  flake.nixosModules.base =
    { ... }:
    {
      imports = with self.nixosModules; [
        nix
      ];

      programs.git.enable = true;
    };
}
