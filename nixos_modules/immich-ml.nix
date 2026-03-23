# This is completely taken from https://kirarin.hootr.club/git/steinuil/flakes/src/commit/ca508fe53af0edd87d0966f900e6d036a616b671/modules/nixos/immich-ml/default.nix
# Thanks to steen for this code. https://sgt.hootr.club/me/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.preconf.immich-ml;
in
{
  options.preconf.immich-ml = with lib; {
    enable = mkEnableOption "Immich ML service";

    port = mkOption {
      type = types.port;
      default = 3003;
    };

    host = mkOption {
      type = types.str;
      default = "[::]";
    };

    workers = mkOption {
      type = types.ints.positive;
      default = 1;
    };

    workerTimeout = mkOption {
      type = types.ints.positive;
      default = 120;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.sockets.immich-ml = {
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "0.0.0.0:${toString cfg.port}" ];
      socketConfig.Accept = false;
    };

    systemd.services.immich-ml = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        IMMICH_HOST = cfg.host;
        IMMICH_PORT = toString cfg.port;
        MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich-ml";
        IMMICH_MACHINE_LEARNING_WORKERS = toString cfg.workers;
        IMMICH_MACHINE_LEARNING_WORKER_TIMEOUT = toString cfg.workerTimeout;
        MPLCONFIGDIR = "/var/lib/immich-ml";
      };
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.immich-machine-learning}";
        PrivateDevices = false;
        # DeviceAllow = null;
        StateDirectory = "immich-ml";
        CacheDirectory = "immich-ml";

        # Hardening
        DynamicUser = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictRealtime = true;
        UMask = "0077";
      };
    };
  };
}
