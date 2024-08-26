{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  focusApp = windowClass: failLaunch: "${lib.getExe pkgs.focusScript} ${windowClass} ${failLaunch}";

  # GTK cursor size fix? https://discourse.nixos.org/t/cursor-size-in-wayland-sway/25112/4

  changeWallpaper = pkgs.writeShellApplication {
    name = "changeWallpaper";
    text = ''      wallpapers=$(echo "${wallpaperPaths}" | tr ' ' '\n')
           chosenwallpaper=$(echo "$wallpapers" | shuf -n 1)

           hyprctl hyprpaper preload "$chosenwallpaper"
           hyprctl hyprpaper wallpaper ",$chosenwallpaper"

           hyprctl hyprpaper unload all
           echo "$chosenwallpaper"
    '';
  };

  wallpaperPaths =
    lib.concatStringsSep " "
    (map (path: "${inputs.catppuccin-wallpaper-repo}/${path}")
      [
        "landscapes/forrest.png"
        "landscapes/Clearnight.jpg"
        # "landscapes/Cloudsday.jpg"
        "landscapes/Cloudsnight.jpg"
        "landscapes/tropic_island_night.jpg"

        "minimalistic/list-horizontal.png"

        "misc/cat_bunnies.png"
        "misc/windows-error.jpg"
        "waves/cat-waves.png"
      ]);
in {
  options = {
    preconf.hyprland.enable = lib.mkEnableOption "Enable preconfigured Hyperland";
  };

  config = {
    home.packages = with pkgs; [
      # Required to make desktop entries
      xdg-utils
    ];

    xdg.desktopEntries = {
      changeWallpaper = {
        name = "Change Wallpaper";
        exec = "${lib.getExe changeWallpaper}";
      };
    };
    services.dunst = {
      enable = true;
      catppuccin.enable = true;
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${./../../wallpapers/nix.png}";
        wallpaper = ",${./../../wallpapers/nix.png}";
      };
    };

    wayland.windowManager.hyprland.catppuccin.enable = true;
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = "workspace special:Chat, initialtitle:^(chatgpt\.com_/)$";
      #     windowrulev2 = float,class:(qalculate-gtk)
      # windowrulev2 = workspace special:calculator,class:(qalculate-gtk)
      # bind = SUPER, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &
      exec-once = [
        "waybar"
        "syncthing &"
        "dunst"
        "dbus-update-activation-environment --systemd --all"
        "${lib.getExe changeWallpaper}"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

        "wl-paste --type text --watch cliphist store" # Make text available in clipboard history
        "wl-paste --type image --watch cliphist store" # Make images available in clipboard history
      ];

      input = {
        kb_layout = "se";
        kb_variant = "nodeadkeys";
        kb_options = "caps:swapescape";
      };

      "$mod" = "SUPER";

      input.touchpad = {
        natural_scroll = true;
        scroll_factor = 0.6;
      };

      gestures.workspace_swipe = true;

      # options.xdg.desktopEntries = {
      #   ocr-copy = {
      #     name = "ocr screen copy";
      #     exec = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
      #   };

      bind =
        [
          "SUPER, g, exec, bash ${./scripts/chatgpt.sh}"

          "SUPER_SHIFT, B, exec, ${focusApp "firefox" "firefox"}"
          "SUPER, B, exec, firefox"

          "$mod, Return, exec, alacritty"
          "SUPER_SHIFT, Return, exec, ${focusApp "Alacritty" "alacritty"}"

          "SUPER_SHIFT, c, killactive"

          "SUPER_SHIFT, q, exec, bash ${./../../scripts/powerMenu.sh}"
          "SUPER_ALT, m, exec, bash ${./../../scripts/mynixos.sh}"

          "SUPER, s, exec, ${focusApp "sioyek" "sioyek"}"
          "SUPER, n, exec, ${focusApp "com.github.flxzt.rnote" "rnote"}"
          "SUPER, o, exec, ${lib.getExe pkgs.navigateOpenWindows}"
          ", Print, exec, grimblast copy area"

          # HJKL to switch active window
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          "$mod, SPACE, exec, rofi -show drun -show-icons"

          # HJKL to move active window position
          "SUPER_ALT, h, swapwindow, l"
          "SUPER_ALT, j, swapwindow, d"
          "SUPER_ALT, k, swapwindow, u"
          "SUPER_ALT, l, swapwindow, r"

          # View clipboard history
          "SUPER, V, exec, cliphist list | tofi | cliphist decode | wl-copy"

          # Copy screen selection as image
          ",Print, exec, grim -g \"$(slurp)\" - | wl-copy" #grim -g \"$(slurp)\ | wl-copy"

          "SUPER, f, fullscreen, 0"
          "SUPER, m, fullscreen, 1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
      binde = [
        "SUPER_SHIFT, h, resizeactive, -20 0"
        "SUPER_SHIFT, j, resizeactive, 0 20"
        "SUPER_SHIFT, k, resizeactive, 0 -20"
        "SUPER_SHIFT, l, resizeactive, 20 0"

        # Raise and lower volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ];
    };
  };
}
