{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake = {
    meta.services.immich.url = "immich.${meta.homeNetworkUrl}";

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
          # Maybe change to this
          # reverse_proxy [::1]:${toString config.services.immich.port}
          "reverse_proxy ${immich.host}:${config.port}";
      };
    };
  };
}
