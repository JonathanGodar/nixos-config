{
  flake.modules.nixos.bluetooth = { pkgs, ... }: {
    hardware = {
      bluetooth.enable = true; # enables support for Bluetooth
      bluetooth.powerOnBoot = true;
    };

    environment.systemPackages = with pkgs; [
      bluetui
    ];

  };
}
