{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common
  ];
  networking.hostName = "wax9";

  services.upower.enable = true;

  services.xserver.desktopManager.lxqt.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.sddm.package = pkgs.kdePackages.sddm;
}
