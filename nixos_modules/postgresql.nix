{
  inputs,
  pkgs,
  system,
  lib,
  config,
  ...
}:
{
  options.preconf.postgresql.enable = lib.mkEnableOption "Enable preconfigured postgresql";

  config = lib.mkIf config.preconf.postgresql.enable {
    services.postgresqlBackup = {
      enable = true;
      backupAll = true;
    };
  };
}
