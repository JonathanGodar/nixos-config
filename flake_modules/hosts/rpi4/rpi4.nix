# Has propriatary non open packages cache according to
# substituters = [
#  "https://nix-community.cachix.org"
#  ];
#  trusted-public-keys = [
#  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#  ];
#
#
{
  inputs,
  self,
  config,
  ...
}:
let
  inherit (config.flake) meta;
in
{
  flake = { pkgs, ... }: {
    meta.hosts.rpi4 = {
      wgPublicKey = "VFltFcvkDZrEfa/M2Gt6+eKvJryNUYhpCBvuIljlOAw=";
    };

    nixosConfigurations.rpi4 = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = with self.modules.nixos; [
        rpi4
        homeManager
        {
          home-manager.users.jonathan.imports = [
            self.modules.homeManager.rpi4
          ];
        }
      ];
    };

    modules = {
      nixos.rpi4 = { config, pkgs, ... }: {
        imports = with self.modules.nixos; [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4

          base
          jonathan
          nvim

          immich
          syncthing
          openssh-server
          backup-server
          postgresql
          ddclient
          caddy
          atuin-server
          vaultwarden
          ntfy-sh

          backup
          backup_drive
        ];

        networking.hostName = "rpi4";
        boot.kernelPackages = pkgs.linuxPackages;

        systemOptions.flakePath = "/home/joanthan/nixos";

        # This is set by the SD-installer and needs to be kept.
        fileSystems."/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
        };

        fileSystems."/mnt/ssd" = {
          device = "/dev/vg-ssd/lv-home";
          fsType = "ext4";
        };

        systemd.tmpfiles.settings.rpi4-fs."/mnt/ssd".d = {
          # group = cfg.group;
          # user = cfg.user;
          mode = "0755";
        };

        services = {
          syncthing.dataDir = "/mnt/ssd/syncthing";
        };

        services.borgbackup.repos = {
          borg_repo = {
            authorizedKeys = with meta.hosts; [
              faccun.publicKey
              wax9.publicKey
            ];
            path = "/mnt/ssd/borg";
          };
        };

        services.backup = {
          include_paths = with config; [
            services.immich.mediaLocation
            services.postgresqlBackup.location # This should cover atuin and vaultwarden.
            services.syncthing.dataDir
          ];
        };

        # services.rnote-export = {
        #   enable = true;
        #   user = "syncthing";
        #   group = "syncthing";
        #
        #   inputDirectory = "/mnt/ssd/syncthing/kth";
        #   includeString = "*/föreläsningar/F*.rnote";
        # };

        services.postgresql = {
          dataDir = "/mnt/ssd/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
        };

        services.immich.mediaLocation = "/mnt/ssd/immich";
        # preconf.backup_to_external_drive = {
        #   enable = true;
        #   paths = [
        #     # Include the postgres backup
        #     "/var/backup"
        #
        #     "/var/lib"
        #
        #     # Backup immich
        #     "/mnt/ssd/immich/backups"
        #     "/mnt/ssd/immich/library"
        #     "/mnt/ssd/immich/upload"
        #     "/mnt/ssd/immich/profile"
        #
        #     "/mnt/ssd/syncthing"
        #   ];
        #
        #   exclude = backup_helpers.ignore_directories;
        # };
      };
      homeManager.rpi4 = {
        imports = with self.modules.homeManager; [
          base
        ];

      };
    };
  };

}
