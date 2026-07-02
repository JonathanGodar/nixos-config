{ ... }:
{
  flake.modules.homeManager.nh =
    { osConfig, ... }:
    {
      programs.nh = {
        enable = true;
        flake = osConfig.systemOptions.flakePath;
      };
    };
}
