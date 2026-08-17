{
  flake.modules.nixos.opentabletdriver = {
    hardware.opentabletdriver.enable = true;

    hardware.uinput.enable = true;
    boot.kernelModules = [ "uinput" ];
  };
}
