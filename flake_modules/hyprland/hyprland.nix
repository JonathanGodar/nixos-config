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
          configType = "lua";

          extraConfig =
            # lua
            ''
              require('lua/entry')
            '';
        };

        home.packages = with pkgs; [
          grimblast
        ];

        xdg.configFile."hypr/lua" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/flake_modules/hyprland/lua";
          recursive = true;
        };
      };
  };
}
