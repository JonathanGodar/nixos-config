{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {
    preconf.borgextern_job.enable = lib.mkEnableOption "Enables preconfigured";

  };

  config =
    let
      disk_uuid = "61a60b9c-ec8b-44f8-9d71-b19c4b8f5285";
      job-name = config.networking.hostName + "_extern";
      mount_name = "backup_hdd";
      diskuuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";
    in
    lib.mkIf config.preconf.borgextern_job.enable {
      fileSystems."/backup" = {
        device = "/dev/disk/by-uuid/05fbbe4b-540c-4705-81d3-df2bb043d47e";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      # systemd = {
      #   services."borgbackup-job-${job-name}" = {
      #     requires = [ "${mount_name}.mount" ];
      #     after = [ "${mount_name}.mount" ];
      #   };
      # };
      #
      # services = {
      #   borgbackup.jobs.${job-name} = {
      #     compression = "auto,zstd";
      #     paths = "/home/jonathan/Desktop/";
      #     repo = "/${mount_name}/borgbackup";
      #     startAt = "daily";
      #     encryption.mode = "none";
      #
      #     persistentTimer = true;
      #   };
      # };
    };
}
