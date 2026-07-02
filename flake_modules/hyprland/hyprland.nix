{ ... }:
{
  flake.modules = {
    nixos.hyprland =
      { pkgs, ... }:
      {
        programs.hyprland = {
          # Required for hyprland to work
          enable = true;
          xwayland.enable = true;
        };
      };

    homeManager.hyprland =
      { pkgs, config, ... }:
      {
        wayland.windowManager.hyprland = {
          enable = true;

          extraConfig =
            # lua
            ''
              require('lua/entry.lua')
            '';
        };

        xdg.configFile."hypr/lua" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/flake_modules/hyprland/lua";
          recursive = true;
        };
      };
  };
}
