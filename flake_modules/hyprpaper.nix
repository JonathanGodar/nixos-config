{
  flake.modules.homeManager.hyprpaper = {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${./../wallpapers/nix.png}";
          }
        ];
      };
    };
  };
}
