{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.obsidian.enable = lib.mkEnableOption "Enable obsidian.";
  };

  config = lib.mkIf config.preconf.obsidian.enable {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
      defaultSettings.app = {
        vimMode = true;
        showLineNumber = true;
        relativeLineNumbers = true;
      };
    };
  };
}
