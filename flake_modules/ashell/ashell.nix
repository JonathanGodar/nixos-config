{
  flake.modules.homeManager.ashell =
    { config, ... }:
    {
      programs.ashell = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."ashell/config.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/flake_modules/ashell/config.toml";
      };

      # programs.noctalia = {
      #   enable = true;
      #
      #   settings = {
      #     # This may also be a string or path to a .toml file.
      #     theme = {
      #       mode = "dark";
      #       source = "builtin";
      #       builtin = "Catppuccin";
      #     };
      #   };
      # };
    };
}
