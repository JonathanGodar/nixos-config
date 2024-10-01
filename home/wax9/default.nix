{pkgs, ...}: {
  imports = [../common];

  preconf.cli_full.enable = true;
  preconf.catppuccin.enable = true;
  preconf.kth.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    discord
  ];
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # monitor, resolution, position, scale
      "eDP-1, preferred, 0x0, 2"
      ", preferred, auto, 1, mirror, eDP-1"
    ];

    "$mod" = "SUPER";
    "$MAIN_MONITOR" = "DP-2";
    "$OTHER_MONITOR" = "DP-1";
    };
}
