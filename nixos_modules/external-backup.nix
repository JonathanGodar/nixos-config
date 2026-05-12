{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.backup_to_external_drive = {
      enable = lib.mkEnableOption "Enables preconfigured";
      job_name = lib.mkOption {
        type = lib.types.str;
        default = "external_drive_backup";
      };

      drive_mount_path = lib.mkOption {
        type = lib.types.str;
        default = "/backup";
      };

      exclude = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "What files/directories to ignore";
      };

      paths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "What paths to include in the backup";
      };
    };
  };

  config =
    let
      disk_uuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";

    in
    lib.mkIf config.preconf.backup_to_external_drive.enable {
      fileSystems."${config.preconf.backup_to_external_drive.drive_mount_path}" = {
        device = "/dev/disk/by-uuid/${disk_uuid}";
        fsType = "ext4";
        options = [
          "noauto"
          "nofail"
          # "x-systemd.device-timeout=0"
          # "x-systemd.automount"
        ];
      };

      # This was used once and it worked but it seems to work just as well without it
      # systemd = {
      #   services."borgbackup-job-${job_name}" = {
      #     requires = [ "${mount_name}.mount" ];
      #     after = [ "${mount_name}.mount" ];
      #   };
      # };

      services = {
        # From chatgpt
        udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${disk_uuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="borgbackup-job-${config.preconf.backup_to_external_drive.job_name}.service"
        '';
        borgbackup.jobs.${config.preconf.backup_to_external_drive.job_name} = {
          compression = "auto,zstd";
          paths = config.preconf.backup_to_external_drive.paths;
          exclude = config.preconf.backup_to_external_drive.exclude;
          repo = "${config.preconf.backup_to_external_drive.drive_mount_path}/borgbackup";
          startAt = "daily";
          encryption.mode = "none";
          persistentTimer = true;
          extraCreateArgs = "--verbose --stats";
        };
      };
    };
}
