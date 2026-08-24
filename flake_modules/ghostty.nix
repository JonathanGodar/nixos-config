{ ... }:
{
  flake.modules.homeManager.ghostty =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-size = 10;
        };
      };
    };
}
