{ pkgs, inputs, lib, config, ...}: {
  options.preconf.cursors = {
    enable = lib.mkEnableOption "Enable preconfigured cursors";
    size = lib.mkOption {
      default = 24;
      description = "Set the cursor size";
    };
  };

  imports = [inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger];

  config = let
    size = config.preconf.cursors.size;
    in

    lib.mkIf config.preconf.cursors.enable {
      home.pointerCursor = {
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        inherit size;
        gtk.enable = true;
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          cursor-theme = "phinger-cursors-dark";
          cursor-size = toString size;
        };
      };

      wayland.windowManager.hyprland.settings = lib.mkIf config.preconf.hyprland.enable {
        exec-once = [
          "hyprctl setcursor phinger-cursors-dark ${toString size}"
        ];
      };

      # Imports phinger-hyprcursor variant
      programs.hyprcursor-phinger.enable = lib.mkIf config.preconf.hyprland.enable true;
  };

}
