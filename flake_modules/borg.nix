{ self, lib, ... }:
let
  inherit (self) meta;
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
        borg_common_options =
          backupTarget:
          (
            { config, pkgs, ... }@args:
            let
              ntfy-w = lib.getExe (self.lib.ntfy-w args);
            in
            {
              persistentTimer = true;
              # inhibitsSleep = true;

              paths = config.services.backup.include_paths;
              exclude = config.services.backup.exclude_paths;

              encryption.mode = "none";
              compression = "auto,lzma";
              startAt = "daily";

              extraCreateArgs = "--verbose --stats";

              # Exit codes come from https://borgbackup.readthedocs.io/en/stable/usage/general.html
              postHook = ''
                if [[ $exitStatus -eq 0 ]]; then
                  ${ntfy-w} pub ${ntfy_topic} "Backup ${config.networking.hostName} -> ${backupTarget} done. Exit code $exitStatus"
                elif (( ($exitStatus >= 2 &&  $exitStatus <= 99))); then
                  ${ntfy-w} pub ${ntfy_topic} "ERROR: Backup ${config.networking.hostName} -> ${backupTarget} failed, exit $exitStatus"
                elif (( ($exitStatus == 1) ||  ($exitStatus <= 127 && $exitStatus >= 100))); then
                  ${ntfy-w} pub ${ntfy_topic} "Warning: Backup ${config.networking.hostName} -> ${backupTarget} failed, exit $exitStatus"
                else
                  ${ntfy-w} pub ${ntfy_topic} "Backup ${config.networking.hostName} -> ${backupTarget} exited $exitStatus";
                fi
              '';
            }
          );
      in
      {
        backup = {
          options = {
            services.backup = {
              include_paths = lib.mkOption {
                type = types.listOf types.str;
                default = [ "/" ];
                description = "Paths to include in backups";
              };

              exclude_paths = lib.mkOption {
                type = types.listOf types.str;
                default = self.meta.backup.home_ignores ++ self.meta.backup.wild_card_ignores;
                description = "Paths to exclude from backups";
              };
            };
          };
        };

        backup_rpi4 =
          {
            config,
            pkgs,
            ...
          }@args:
          let
            backup_target = "rpi4";
          in
          {
            systemd = {
              services."borgbackup-job-${backup_target}" = {
                requires = [ "network-online.target" ];
                after = [ "network-online.target" ];
              };
            };

            services.borgbackup.jobs."${backup_target}" = (borg_common_options backup_target args) // {
              environment = {
                BORG_RSH = "ssh -i /home/jonathan/.ssh/id_ed25519";
              };
              user = "jonathan";
              repo = "borg@${meta.homeNetworkUrl}:./";
            };
          };

        backup_drive =
          { config, pkgs, ... }@args:
          let
            disk_uuid = "05fbbe4b-540c-4705-81d3-df2bb043d47e";
            mount_location = "/backup";
            job_name = "external_drive";
          in
          {

            fileSystems."${mount_location}" = {
              device = "/dev/disk/by-uuid/${disk_uuid}";
              fsType = "ext4";
              options = [
                "noauto"
                "nofail"
              ];
            };
            services = {
              # From chatgpt
              udev.extraRules = ''
                ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${disk_uuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="borgbackup-job-${job_name}.service"
              '';

              borgbackup.jobs.${job_name} =
                let
                  job_cfg = (borg_common_options job_name args);
                in
                job_cfg
                // {
                  repo = "${mount_location}/borgbackup";
                  # postHook = job_cfg.postHook + "\n ${lib.getExe pkgs.umount} ${mount_location}";
                };
            };
          };

        backup-server = {
          services.borgbackup.repos = {
            borg_repo = {
              authorizedKeys = with meta.hosts; [
                faccun.publicKey
                wax9.publicKey
              ];
              path = "/mnt/ssd/borg";
            };
          };
        };
      };

    meta.backup = {
      home_ignores = map (x: "/home/*/" + x) [
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
        ".local/share/containers/"
        ".local/share/Steam/"

        ".npm/"
        ".m2/repository/"
        ".gradle/caches/"
        ".virtualenvs/"

        # From WAX9
        "VirtualBox VMs/"
        "bin/MATLAB/"
        ".MathWorks"
      ];

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
