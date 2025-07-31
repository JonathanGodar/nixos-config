{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    preconf.vaultwarden.enable = lib.mkEnableOption "Enable preconfigured vaultwarden";
  };
  config = lib.mkIf config.preconf.vaultwarden.enable {
    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        config = {
          DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          DOMAIN = "https://pass.ngodag.com";
        };
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
}
