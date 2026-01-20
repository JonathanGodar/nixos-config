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
      job-name = config.networking.hostName + "_extern";
      mount_name = "backup";
      disk_uuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";

      ignored_directory_names = [
        "**/Cache"
        "**/cache"
        "**/.cache/"
        "**/target/**"
        "**/build/**"
        "**/__pycache__/**"
        "**/.venv/**"
        "**/venv/**"
        "**/node_modules/**"

        "**/tmp/"
        "**/.git/"
        "**/pyc"

        "**/node_modules/"

        "**/DistantHorizons.sqlite"
      ];

      ignored_home_files = [
        ".cargo/"
        ".eclipse/"
        ".discord-rpc/"
        ".java/"
        ".julia/"
        ".nix-profile/"
        ".ssh/"
        ".vscode/"
        ".zconpdump"
        ".zshenv"
        ".zshrc"
        "Downloads/"

        ".mozilla/firefox/*.default-release/cache2/"
        ".mozilla/firefox/"
        ".config/discord/"
        ".config/google-chrome/Default/Cache/"
        ".config/chromium/"
        ".local/share/Trash/"
        ".local/share/containers"
        ".local/share/Steam"

        ".npm/"
        ".m2/repository/"
        ".gradle/caches/"
        ".virtualenvs/"
      ];

    in
    lib.mkIf config.preconf.borgextern_job.enable {
      fileSystems."/${mount_name}" = {
        device = "/dev/disk/by-uuid/${disk_uuid}";
        fsType = "ext4";
        options = [ "nofail" ];
      };

      # This was used once and it worked but it seems to work just as well without it
      # systemd = {
      #   services."borgbackup-job-${job-name}" = {
      #     requires = [ "${mount_name}.mount" ];
      #     after = [ "${mount_name}.mount" ];
      #   };
      # };

      services = {
        borgbackup.jobs.${job-name} = {
          compression = "auto,zstd";
          paths = "/home/jonathan/Desktop/";
          repo = "/${mount_name}/borgbackup";
          startAt = "daily";
          encryption.mode = "none";
          persistentTimer = true;
        };
      };
    };
}
