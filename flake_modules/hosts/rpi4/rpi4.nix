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
      nixos.rpi4 = { config, ... }: {
        imports = with self.modules.nixos; [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4

          base
          jonathan
          nvim

          syncthing
          openssh-server
          postgresql
          ddclient
          caddy
          atuin
          vaultwarden
        ];

        boot.kernelPackages = pkgs.linuxPackages;

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

        services.rnote-export = {
          enable = true;
          user = "syncthing";
          group = "syncthing";

          inputDirectory = "/mnt/ssd/syncthing/kth";
          includeString = "*/föreläsningar/F*.rnote";
        };

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

        services.caddy = {
          enable = true;
          virtualHosts = {
            "ant.${config.home_network_url}" = {
              extraConfig = ''
                root * /var/lib/rnote-export/
                file_server browse
                header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate"
              '';
            };

            "atuin.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy :8888
              '';
            };

            "faccun.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy 192.168.1.83:3344
              '';
            };

            "pass.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT}
              '';
            };

            "immich.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy [::1]:${toString config.services.immich.port}
              '';
            };

            "tun1.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy :9001
              '';
            };

            "tun2.${config.home_network_url}" = {
              extraConfig = ''
                reverse_proxy :9002
              '';
            };
          };
        };
      };
      homeManager.rpi4 = {
      };
    };
  };

}
