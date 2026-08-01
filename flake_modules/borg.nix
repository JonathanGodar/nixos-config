{ self, lib, ... }:
let
  inherit (lib) types;
in
{
  flake = {

    modules.nixos = {
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

      backup_drive =
        { config, ... }:
        let
          disk_uuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";
          mount_location = "/backup";
          job_name = "external_drive_backup";
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
