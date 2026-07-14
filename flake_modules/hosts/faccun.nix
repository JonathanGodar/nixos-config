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
