{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.meta.services.atuin.url = "atuin.${meta.homeNetworkUrl}";

  flake.modules = {
    nixos.atuin-server = {
      services = {
        atuin = {
          enable = true;
          database.createLocally = true;
        };

        postgresql = {
          enable = true;
        };

        caddy.virtualHosts."${meta.services.atuin.url}".extraConfig = "reverse_proxy :8888";
      };
    };

    homeManager.atuin = {
      programs.atuin = {
        enable = true;
        daemon.enable = true;
        settings = {
          sync_frequency = "0";
          sync_address = "https://${meta.services.atuin.url}";
          invert = true;
        };
        enableNushellIntegration = true;
      };
    };
  };
}
