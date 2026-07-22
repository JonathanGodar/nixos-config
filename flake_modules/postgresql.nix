{
  flake.modules.nixos.postgresql = {

    services = {
      postgresql = {
        enable = true;
      };

      postgresqlBackup = {
        enable = true;
        backupAll = true;
      };
    };

  };
}
