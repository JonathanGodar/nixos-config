{ pkgs, inputs, lib, config, ...}: {
  options.preconf.backups = {
    enable = lib.mkEnableOption "Enable backups";
  };

  config = lib.mkIf config.preconf.backups.enable {
    # boot.zfs.enabled = true;
  };
}
