{ ... }:
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        # Required for hyprland to work
        enable = true;
        xwayland.enable = true;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
}
