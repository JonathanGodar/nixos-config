{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];
  # options.preconf.hyprland_de.enable = lib.mkEnableOption "Enable preconfigured hyprland with DE-like preconfigurations";

  options = {
    rpi4_fs.enable = lib.mkOption {
      default = true;
      description = "Configure the raspberry pi 4 file system";
    };
  };

  config = lib.mkIf config.rpi4_fs.enable {
    # Choose a linux kernel that does not have to be built from scratch
    boot.kernelPackages = pkgs.linuxPackages;

    # This is set by the SD-installer and needs to be kept.
    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    fileSystems."/mnt/ssd" = {
      device = "/dev/vg-ssd/lv-home";
      fsType = "ext4";
    };

    systemd.tmpfiles.settings.rpi4-fs."/mnt/ssd".d = {
      # group = cfg.group;
      # user = cfg.user;
      mode = "0755";
    };

    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = "524288"; # Increase default
    };

    #    boot = {
    #      kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    # loader = {
    #   generic-extlinux-compatible.enable = lib.mkDefault true;
    #   grub.enable = lib.mkDefault false;
    # };
    #    };
  };
}
