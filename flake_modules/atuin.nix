{ config, ... }:
{
  flake.serviceEndpoints.atuin = "https://atuin.ngodag.com";

  flake.modules = {
    nixos.atuin-server = {
      services.atuin = {
        enable = true;
        database.createLocally = true;
      };

      services.postgresql = {
        enable = true;
      };
    };

    homeManager.atuin = {
      programs.atuin = {
        enable = true;
        daemon.enable = true;
        settings = {
          sync_frequency = "0";
          sync_address = "${config.flake.serviceEndpoints.atuin}";
          invert = true;
        };
        enableNushellIntegration = true;
      };
    };
  };
}
