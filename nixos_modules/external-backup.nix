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
      job-name = config.networking.hostName + "_exter";
      mount_point = "/mnt/borgbackupmount/";
      repo_path = mount_point + "borgbackuprepo/";
      # disk_ptuuid = "b2bda24d-5429-4619-9d8d-decc6ed803d";
    in
    lib.mkIf config.preconf.borgextern_job.enable {
      systemd.services.${job-name} = {
        unitConfig.RequiresMountsFor = lib.mkForce [ ];
        serviceConfig.RequiresMountsFor = lib.mkForce [ ];
      };

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${disk_uuid}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="borgbackup-job-${job-name}.service"
      '';
      services.borgbackup.jobs = {
        ${job-name} =
          let
            notify-send = lib.getExe pkgs.libnotify;
          in
          {
            persistentTimer = true;

            preHook = ''
              mkdir -p ${mount_point}
              mount -U ${disk_uuid} ${mount_point}
              mkdir -p ${repo_path}
            '';
            # ${notify-send} -t 0 "Starting backup"

            postHook = ''
              umount /dev/disk/by-uuid/${disk_uuid}
              if [[ $exitStatus -eq 0 ]]; then
                ${notify-send} -t 0 "Backup done"
              else
                ${notify-send} -u critical -t 0 "Backup failed" "Backup job exited with status $exitStatus"
              fi
            '';

            paths = "/home/jonathan/";

            exclude =
              (map (path: "/home/jonathan/" + path) [
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
              ])
              ++ [
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
            environment = {
              # BORG_RSH = "ssh -i /home/jonathan/.ssh/id_ed25519";

              # Required to let notify-session access DBUS.
              # This is really ugly because i have hard coded the my users UID (which is 1000).
              # DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
            };

            extraCreateArgs = "--verbose --stats";

            # user = "jonathan";
            # Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus

            repo = repo_path;
            encryption.mode = "none";
            compression = "auto,lzma";

            # Removes the timer
            startAt = [ ];
            removableDevice = true;
          };
      };

    };
}
