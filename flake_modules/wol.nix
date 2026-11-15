{ ... }: {
  # TODO fix so that the interface comes from e.g meta.hosts.wolIface
  flake.modules.nixos.wakeonlan =
    let
      iface = "enp4s0";
    in
    { pkgs, ... }: {
      systemd.services.wake-on-lan = {
        description = "Enable Wake-on-LAN";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${iface} wol g";
        };
      };

    };
}
