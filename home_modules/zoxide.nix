{
  lib,
  config,
  ...
}: {
  options = {
    preconf.zoxide.enable = lib.mkEnableOption "Enable zoxide";
  };

  config = lib.mkIf config.preconf.zoxide.enable {
    programs.zoxide.enable = true;
  };
}
