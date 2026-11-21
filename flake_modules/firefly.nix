{ self, inputs, ... }:
let
  firefly_port = 3000;
in
{
  flake.modules.nixos.firefly_vm = { pkgs, ... }: {
    imports = [ inputs.microvm.nixosModules.host ];

    microvm.vms = {
      firefly = {
        inherit pkgs;
        config = {
          # It is highly recommended to share the host's nix-store
          # with the VMs to prevent building huge images.
          microvm = {

            shares = [
              {
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }
            ];

            forwardPorts = [
              {
                from = "host";
                host.port = 3001;
                guest.port = firefly_port;
                proto = "tcp";
              }
            ];

            interfaces = [
              {
                type = "user";
                id = "firefly";
                mac = "02:00:00:01:01:02";
              }
            ];

          };

          networking = {
            hostName = "firefly";
            firewall.allowedTCPPorts = [
              firefly_port
            ];
          };

          system.stateVersion = "24.05";

          imports = [
            self.modules.nixos.firefly
          ];

          # Any other configuration for your MicroVM
          # [...]
        };

      };
    };
  };

  flake.modules.nixos.firefly = { pkgs, ... }: {
    services.firefly-iii-data-importer = {
      enable = true;
      enableNginx = true;
      virtualHost = "127.0.0.1";
      settings = {
        FIREFLY_III_URL = "http://192.168.1.83";
        VANITY_URL = "http://127.0.0.1:3000";
      };
    };

    services.nginx.virtualHosts."127.0.0.1".listen = [
      {
        addr = "127.0.0.1";
        port = 3000;
      }
    ];

    services.firefly-iii = {
      enable = true;
      enableNginx = true; # default; serves the PHP app
      virtualHost = "192.168.1.83";
      settings.APP_KEY_FILE = pkgs.writeTextFile {
        name = "firefly-iii-app-secret.txt";
        text = "base64:7gY9LrnyyCDhCaUxxQ9AnPzzwoewGyxwQ/b013P2bdA";
      };

    };
  };
}
