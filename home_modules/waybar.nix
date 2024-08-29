{
  pkgs,
  lib,
  config,
  ...
}: {
  options.preconf.waybar.enable = lib.mkEnableOption "Enable preconfigured waybar";
  config = lib.mkIf config.preconf.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          modules-left = ["hyprland/workspaces" "hyprland/mode" "wlr/taskbar"];
          modules-center = ["hyprland/window"];
          modules-right = ["tray" "battery" "clock" "wireplumber"];
        };
      };
    };
  };
}
