{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.nh.enable = lib.mkEnableOption "Enable nix helper.";
  };

  config = lib.mkIf config.preconf.nh.enable {
    programs.nh = {
      enable = true;
      flake = "/home/jonathan/nixos/";
    };

  };
}
