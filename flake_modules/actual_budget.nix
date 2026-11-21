{ self, inputs, ... }: {
  flake.modules.nixos.actual_budget_vm = { pkgs, ... }: {
    imports = [ inputs.microvm.nixosModules.host ];

    microvm.vms = {
      actual = {
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
                host.port = 3000;
                guest.port = 3000;
                proto = "tcp";
              }
              {
                from = "host";
                host.port = 5006;
                guest.port = 5006;
                proto = "tcp";
              }
            ];

            interfaces = [
              {
                type = "user";
                id = "actual";
                mac = "02:00:00:01:01:01";
              }
            ];

          };

          networking = {
            hostName = "actual";
            firewall.allowedTCPPorts = [
              5006
              3000
            ];
          };

          system.stateVersion = "24.05";

          imports = [
            self.modules.nixos.actual_budget
          ];

          # Any other configuration for your MicroVM
          # [...]
        };

      };
    };
  };

  flake.modules.nixos.actual_budget = { pkgs, ... }: {
    services.actual.enable = true;
  };
}
