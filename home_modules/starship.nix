{
  lib,
  config,
  ...
}: {
  options = {
    preconf.starship.enable = lib.mkEnableOption "Enable configured starship";
  };

  config = lib.mkIf config.preconf.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        direnv.disabled = false;
        directory.truncate_to_repo = false;
      };
    };
  };
}
