{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    preconf.ghostty.enable = lib.mkEnableOption "Enable preconfigured ghostty";
  };
  config = lib.mkIf config.preconf.ghostty.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 10;
        command = "zellij";
      };
    };
    catppuccin.ghostty.enable = true;
  };
}
