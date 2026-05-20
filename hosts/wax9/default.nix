{ pkgs, config, ... }:
let
  backup_helpers = import ../../nixos_modules/backup_helpers.nix { };
in
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
  # services.desktopManager.cosmic.enable = true;
  services.displayManager.sddm.package = pkgs.kdePackages.sddm;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  # preconf.backup_to_external_drive = {
  #   enable = true;
  #   paths = [ "/home/jonathan/" ];
  #   exclude =
  #     (map (path: "/home/jonathan/" + path) backup_helpers.home_ignore_directories)
  #     ++ backup_helpers.ignore_directories;
  # };

  preconf.virtualbox.enable = false;
  preconf.spotify.enable = true;
}
