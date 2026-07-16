{ self, ... }:
{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      programs = {
        dconf.enable = true;
      };

      # Enables wayland support for chromium and electron based apps
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      # services.xserver = {
      #   enable = true;
      # };
      #

      # Music player daemon
      services = {
        mpd.enable = true;
        displayManager = {
          ly = {
            enable = true;
          };
          defaultSession = "hyprland";
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

  flake.modules.homeManager.gui =
    { ... }:
    {
    };
}
