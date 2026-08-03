{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.ddclient = { config, ... }: {
    age.secrets.namecheap_ddns_password = {
      file = ../secrets/namecheap_ddns_token.age;
      mode = "444";
    };

    services.ddclient = {
      enable = true;
      protocol = "namecheap";
      username = "${meta.homeNetworkUrl}";
      passwordFile = config.age.secrets.namecheap_ddns_password.path;
      domains = [
        "@"
        "*"
      ];
    };

  };
}
