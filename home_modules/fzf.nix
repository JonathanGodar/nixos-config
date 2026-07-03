{
  config,
  lib,
  ...
}:
{
  options.preconf.fzf.enable = lib.mkEnableOption "Enable fzf";
  config = lib.mkIf config.preconf.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      # TODO Exists in upstream HM - but inputs update needed
      # enableNushellIntegration = true;
    };
  };
}
