{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake = {
    meta.services.immich.url = "pass.${meta.homeNetworkUrl}";

    modules.nixos.immich = {
      services.immich = {
        enable = true;
        machine-learning.enable = false;
      };

      services.caddy.virtualHosts = {
        ${meta.services.immich.url} =
          let
            inherit (config.services) immich;
          in
          "reverse_proxy ${immich.host}:${config.port}";
      };
    };
  };
}
