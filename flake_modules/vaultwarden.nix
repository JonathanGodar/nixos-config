{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake = {
    meta.services.vaultwarden.url = "pass.${meta.homeNetworkUrl}";

    modules.nixos.vaultwarden = { config, ... }: {
      services = {
        vaultwarden = {
          enable = true;
          dbBackend = "postgresql";
          config = {
            DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
            DOMAIN = "https://${meta.services.vaultwarden.url}";
          };
        };

        services.caddy.virtualHosts = {
          ${meta.services.vaultwarden.url} =
            let
              inherit (config.services.vaultwarden) config;
            in
            "reverse_proxy ${config.ROCKET_ADDRESS}:${config.ROCKET_PORT}";
        };

        # Postgresql setup taken from atuin nixos service: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/atuin.nix
        # sudo -u vaultwarden psql to access the vaultwarden database via psql cli.
        postgresql = {
          ensureUsers = [
            {
              name = "vaultwarden";
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ "vaultwarden" ];
        };
      };
    };
  };
}
