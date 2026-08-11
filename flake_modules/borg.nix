{ self, lib, ... }:
let
  inherit (lib) types;
in
{
  #For rapsberry pi
  #
  # # Include the postgres backup
  # "/var/backup"
  #
  # "/var/lib"
  #
  # # Backup immich
  # "/mnt/ssd/immich/backups"
  # "/mnt/ssd/immich/library"
  # "/mnt/ssd/immich/upload"
  # "/mnt/ssd/immich/profile"
  #
  # "/mnt/ssd/syncthing"
  flake = {
    modules.nixos =
      let
        ntfy_topic = "backup";
      in
      {
        backup = {
          options = {
            services.backup = {
              include_paths = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Paths to include in backups";
              };

              exclude_paths = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Paths to exclude from backups";
              };
            };
          };
        };

        backup_rpi4 =
          {
            config,
            lib,
            ...
          }:
          let
            job_name = "${config.networking.hostName}_rpi4_backup";
          in
          {

            imports = [
              self.modules.nixos.notifaj
            ];

            systemd = {
              services."borgbackup-job-${job_name}" = {
                requires = [ "network-online.target" ];
                after = [ "network-online.target" ];
              };
            };

            services.borgbackup.jobs."${job_name}" = {
              persistentTimer = true;

              preHook = ''
                notifaj ${ntfy_topic} "Starting ${config.networking.hostName}->RPI backup"
              '';

              postHook = ''
                if [[ $exitStatus -eq 0 ]]; then
                  notifaj ${ntfy_topic} "Backup ${config.networking.hostName} -> RPI done"
                else
                  notifaj ${ntfy_topic} "Backup  ${config.networking.hostName} -> RPI failed, Backup job exited with status $exitStatus"
                fi
              '';

              paths = config.services.backup.include_paths;

              exclude = config.services.backup.exclude_paths;

              environment = {
                BORG_RSH = "ssh -i /home/jonathan/.ssh/id_ed25519";

                # Required to let notify-session access DBUS.
                # This is really ugly because i have hard coded the my users UID (which is 1000).
                DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
              };

              extraCreateArgs = "--verbose --stats";

              user = "jonathan";
              # Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus

              repo = "borg@${config.home_network_url}:./";
              encryption.mode = "none";
              compression = "auto,lzma";
              startAt = "daily";
            };
          };

        backup_drive =
          { config, ... }:
          let
            disk_uuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";
            mount_location = "/backup";
            job_name = "${config.networking.hostName}_external_drive_backup";
          in
          {

            imports = [
              self.modules.nixos.backup
            ];

            fileSystems."${mount_location}" = {
              device = "/dev/disk/by-uuid/${disk_uuid}";
              fsType = "ext4";
              options = [
                "noauto"
                "nofail"
                # "x-systemd.device-timeout=0"
                # "x-systemd.automount"
              ];
            };
            services = {
              # From chatgpt
              udev.extraRules = ''
                ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${disk_uuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="borgbackup-job-${job_name}.service"
              '';
              borgbackup.jobs.${job_name} = {
                compression = "auto,zstd";
                paths = config.services.backup.include_paths;
                exclude = config.services.backup.exclude_paths;
                repo = "${mount_location}/borgbackup";
                startAt = "daily";
                encryption.mode = "none";
                persistentTimer = true;
                extraCreateArgs = "--verbose --stats";
              };
            };
          };
      };

    meta.backup = {
      wild_card_ignores = [
        "**/Cache"
        "**/cache"
        "**/.cache/"
        "**/target/**"
        "**/build/**"
        "**/__pycache__/**"
        "**/.venv/**"
        "**/venv/**"
        "**/node_modules/**"

        "**/.stversions"

        "**/tmp/"
        "**/.git/"
        "**/pyc"

        "**/*.log"

        "**/node_modules/"

        "**/DistantHorizons.sqlite"

      ];
    };
  };
}
