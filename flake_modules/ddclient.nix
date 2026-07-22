{ config, ... }: {
  flake.modules.nixos.ddclient = {
    services.ddclient = {
      enable = true;
      protocol = "namecheap";
      username = "${config.meta.homeNetworkUrl}";
      # TODO fix this with ragenix instead
      passwordFile = "/mnt/ssd/syncthing/misc/secrets/namecheap_ddns_password";
      domains = [
        "@"
        "*"
      ];
    };

  };
}
