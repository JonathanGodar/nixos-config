{
  pkgs,
  lib,
  config,
  ...
}: {
  options.preconf.hyprland_de.enable = lib.mkEnableOption "Enable preconfigured hyprland with DE-like preconfigurations";

  config = lib.mkIf config.preconf.hyprland_de.enable {
    preconf.hyprland.enable = true;
    preconf.alacritty.enable = true;
  };
}
