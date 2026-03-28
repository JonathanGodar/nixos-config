{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  options.preconf.zellij.enable = lib.mkEnableOption "Enable zellij";
  config = lib.mkIf config.preconf.zellij.enable {
    programs.zellij = {
      enable = true;
      extraConfig = builtins.readFile ./config.kdl;
      settings = {
        pane_frames = false;
      };
      #   show_startup_tips = false;
    };
  };
}
