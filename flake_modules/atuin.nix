{ ... }:
{
  flake.modules = {
    nixos.atuin-server =
      { ... }:
      {
        services.atuin = {
          enable = true;
          database.createLocally = true;
        };

        services.postgresql = {
          enable = true;
        };
      };
  };
}
