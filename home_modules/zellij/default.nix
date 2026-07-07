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
        default_shell = "${lib.getExe pkgs.nushell}";
        default_layout = "${./layouts/better_default.kdl}";
      };
    };
  };
}
