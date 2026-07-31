{ inputs, self, ... }:
{
  flake = {
    meta.hosts.wax9 = {
      publicKey = builtins.readFile ./wax9.pub;
    };

    nixosConfigurations.wax9 = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.wax9
      ];
    };

    modules = {
      nixos.wax9 =
        { config, ... }:
        {
          imports = with self.modules.nixos; [
            workstation
            upower

            wax9Hardware
            homeManager
            {
              home-manager.users.jonathan.imports = [
                self.modules.homeManager.wax9
              ];
            }
          ];

          networking.hostName = "wax9";

          services.xserver.videoDrivers = [ "nvidia" ];

          hardware.graphics = {
            enable = true;
          };

          hardware.nvidia = {
            # Modesetting is required.
            modesetting.enable = true;

            # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
            # Enable this if you have graphical corruption issues or application crashes after waking
            # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
            # of just the bare essentials.
            powerManagement.enable = false;

            # Fine-grained power management. Turns off GPU when not in use.
            # Experimental and only works on modern Nvidia GPUs (Turing or newer).
            powerManagement.finegrained = false;

            # Use the NVidia open source kernel module (not to be confused with the
            # independent third-party "nouveau" open source driver).
            # Support is limited to the Turing and later architectures. Full list of
            # supported GPUs is at:
            # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
            # Only available from driver 515.43.04+
            # Currently alpha-quality/buggy, so false is currently the recommended setting.
            open = false;

            # Enable the Nvidia settings menu,
            # accessible via `nvidia-settings`.
            nvidiaSettings = true;

            # Optionally, you may need to select the appropriate driver version for your specific GPU.
            package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          };
        };

      homeManager.wax9 = {
        imports = with self.modules.homeManager; [
          workstation
        ];

        wayland.windowManager.hyprland = {
          extraConfig =
            # lua
            ''
              require("lua/wax9_monitors")
            '';
        };
      };
    };
  };

}
