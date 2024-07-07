{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common
  ];
  networking.hostName = "wax9";
  services.libinput.touchpad.naturalScrolling = true;
}
