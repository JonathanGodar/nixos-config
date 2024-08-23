{
  lib,
  config,
  ...
}: {
  options = {
    preconf.cli_full.enable = lib.mkEnableOption "Enable CLI programes";
  };

  config = lib.mkIf config.preconf.cli_full.enable {
    preconf.cli.enable = true;
    preconf.tmux.enable = true;
    preconf.lazygit.enable = true;
  };
}
