{
  flake.modules.nixos.postgresql = {
    enable = true;
    backupAll = true;
  };
}
