{ self, ... }:
let
  inherit (self) meta;
in
{
  flake.modules.nixos = {

    wireguard_server = { config, ... }: {
      # TODO set netowrking refresh thing so that the dns name resolution is periodically updated!
      # Set this in laptop and desktop config!
      # dynamicEndpointRefreshSeconds = 20;

      age.secrets.wg_rpi4_pk.file = ../secrets/wg_rpi4_pk.age;

      networking.wireguard = {
        interfaces.wg0 = {
          ips = [ "10.100.0.1/24" ]; # Have last byte for subnet
          privateKeyFile = config.age.secrets.wg_rpi4_pk.path;
          listenPort = 32232;

          peers = [
            {
              publicKey = meta.hosts.faccun.wgPublicKey;
              allowedIPs = [ "10.100.0.2/32" ];
            }
          ];
        };
      };

      networking.firewall.allowedUDPPorts = [
        32232
      ];

    };

    wireguard_client =
      { config, ... }:
      let
        hostName = config.networking.hostName;
      in
      {
        age.secrets."wg_${hostName}_pk".file = ../secrets/wg_${hostName}_pk.age;

        networking.wireguard = {
          interfaces.wg0 = {
            ips = [ "${meta.hosts.${hostName}.wgIp}/24" ];
            privateKeyFile = config.age.secrets."wg_${hostName}_pk".path;

            peers = [
              {
                publicKey = meta.hosts.rpi4.wgPublicKey;

                allowedIPs = [
                  "10.100.0.0/24"
                ];

                endpoint = "${meta.homeNetworkUrl}:32232";
              }
            ];
          };
        };
      };

  };
}
