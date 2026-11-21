{ self, ... }:
let
  inherit (self) meta;
in
{
  flake.modules.nixos = {

    wireguard_server =
      { config, ... }:
      let
        hostName = config.networking.hostName;
      in

      {
        # TODO set netowrking refresh thing so that the dns name resolution is periodically updated!
        # Set this in laptop and desktop config!
        # dynamicEndpointRefreshSeconds = 20;
        age.secrets."wg_${hostName}_pk".file = ../secrets/wg_${hostName}_pk.age;

        networking.wireguard = {
          interfaces.wg0 = {
            ips = [ "10.100.0.1/24" ]; # Have last byte for subnet
            privateKeyFile = config.age.secrets."wg_${hostName}_pk".path;
            listenPort = 32232;

            peers = [
              # {
              #   publicKey = meta.hosts.faccun.wgPublicKey;
              #   allowedIPs = [ "10.100.0.2/32" ];
              # }
              {
                publicKey = meta.hosts.wax9.wgPublicKey;
                allowedIPs = [ "10.100.0.3/32" ];
              }
            ];
          };
        };

        networking.firewall.allowedUDPPorts = [
          32232
          1234
        ];
        networking.firewall.allowedTCPPorts = [
          32232
          1234
        ];

        boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = 2; # loose
        networking.firewall.checkReversePath = "loose";

        networking.firewall.trustedInterfaces = [
          "wg0"
        ];

      };

    wireguard_client =
      { config, ... }:
      let
        hostName = config.networking.hostName;
      in
      {
        age.secrets."wg_${hostName}_pk".file = ../secrets/wg_${hostName}_pk.age;
        networking.firewall.checkReversePath = "loose";
        boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = 2; # loose

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

                endpoint = "192.168.1.83:32232";
                # endpoint = "${meta.homeNetworkUrl}:32232";
                # persistentKeepalive = 10;
              }
            ];
          };
        };
        networking.firewall.trustedInterfaces = [ "wg0" ];

        networking.firewall.allowedUDPPorts = [
          1234
        ];
        networking.firewall.allowedTCPPorts = [
          1234
        ];
      };

  };
}
