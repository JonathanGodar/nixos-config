{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common
  ];
  networking.hostName = "wax9";

  services.upower.enable = true;

  services.libinput.touchpad.naturalScrolling = true;
  services.displayManager.sddm.package = pkgs.kdePackages.sddm;
}
