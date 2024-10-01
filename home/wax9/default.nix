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
      "eDP-1, 1920x1080@60, 0x0, 1"
      ", preferred, auto, 1, mirror, eDP-1"
      # "DP-2, 1920x1080@144, 1920x0, 1"
      # "Unknown-1, disable"
    ];

    "$mod" = "SUPER";
    "$MAIN_MONITOR" = "DP-2";
    "$OTHER_MONITOR" = "DP-1";
    };
}
