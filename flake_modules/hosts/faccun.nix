{ inputs, self, ... }:
{
  flake = {
    # Innan kan byta
    # direnv
    # dusnt
    # comma
    nixosConfigurations.faccun = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.faccunConfig
      ];
    };

    modules = {
      nixos.faccunConfig =
        {
          config,
          pkgs,
          ...
        }:
        {
          imports = with self.modules.nixos; [
            workstation
            faccunHardware

            # For home-manager
            homeManager # Activates home-manager options
            {
              home-manager.users.jonathan.imports = [
                self.modules.homeManager.faccun # Bootstraps the first home-manager module for the system
              ];
            }
          ];
          networking.hostName = "faccun";
          networking.hostId = "354736d9";

          hardware.graphics = {
            enable = true;
          };

          services.xserver.videoDrivers = [ "nvidia" ];

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
          # hardware.opengl = {
          #   enable = true;
          #   package = config.boot.kernelPackages.nvidiaPackages.stable;
          #   # For 32-bit support (needed for Minecraft, Steam, etc.)
          #   extraPackages = with config.boot.kernelPackages.nvidiaPackages.stable; [
          #     lib32
          #   ];
          # };
          #
          # # Load kernel modules
          # boot.kernelModules = [
          #   "nvidia"
          #   "nvidia_drm"
          #   "nvidia_modeset"
          # ];
          # boot.extraModprobeConfig = ''
          #   options nvidia-drm modeset=1
          # '';
          #
          # # Enable DRM (Direct Rendering Manager) for better Wayland support
          # hardware.nvidia = {
          #   open = false;
          #   modesetting.enable = true;
          #   # powerManagement.enable = true;
          #   # prime = {
          #   # offload.enable = true;
          #   # sync.enable = true;
          #   # };
          # };

          # For X11 (if using Xorg)
          # services.xserver = {
          #   enable = true;
          #   libinput.enable = true;
          #   videoDrivers = [ "nvidia" ];
          # };

          # For Wayland (Hyprland, Sway, etc.)
          # environment.sessionVariables = {
          #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          #   __NV_PRIME_RENDER_OFFLOAD = "1";
          #   __GL_SYNC_DISPLAY_DEVICE = "GPU-${builtins.toString (builtins.length (builtins.readFile "/sys/class/drm/card*-device/uevent"))}";
          # };
        };

      homeManager.faccun =
        { pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            workstation
          ];
          # with self.modules.homeManager; [
          # homeManager
        };
    };
  };
}
