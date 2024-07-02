{pkgs, lib}: {
  imports = [ ../common ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "$OTHER_MONITOR, 1920x1080@144, 0x0, 1"
      "$MAIN_MONITOR, 1920x1080@144, 1920x0, 1"
      "Unknown-1, disable"
    ];

    workspace = [
      # TODO use range selectors instead
      "1, monitor:DP-2,default:true"
      "2, monitor:DP-2"
      "3, monitor:DP-2"
      "4, monitor:DP-2"
      "5, monitor:DP-2"
      "6, monitor:DP-2"
      "7, monitor:DP-2"

      "8, monitor:DP-1,default:true"
      "9, monitor:DP-1"
      "10, monitor:DP-1"
    ];
  };
}
