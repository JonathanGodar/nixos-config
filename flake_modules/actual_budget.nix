{ self, inputs, ... }: {
  flake.modules.nixos.actual_budget_vm = { pkgs, ... }: {
    imports = [ inputs.microvm.nixosModules.host ];

    microvm.vms = {
      actual = {
        inherit pkgs;
        config = {
          # It is highly recommended to share the host's nix-store
          # with the VMs to prevent building huge images.
          microvm.shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];

          imports = [
            self.modules.nixos.actual_budget
          ];

          microvm.forwardPorts = [
            {
              from = "host";
              host.port = 3000;
              guest.port = 3000;
            }
          ];
          microvm.interfaces = [
            {
              type = "user";
              id = "user";
              mac = "02:00:00:01:01:01";
            }
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
