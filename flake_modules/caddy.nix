{
  config,
  ...
}:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.caddy = {
    services.caddy = {
      enable = true;
      virtualHosts = {
        # Together with a ssh -R this can  act as a verry simple ngrok alternative.
        "tun1.${meta.homeNetworkUrl}" = {
          extraConfig = ''
            reverse_proxy :9001
          '';
        };

        "tun2.${meta.homeNetworkUrl}" = {
          extraConfig = ''
            reverse_proxy :9002
          '';
        };
      };
    };
  };
}
