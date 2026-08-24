{
  flake.modules.homeManager.cursors =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
        size = 24;
        gtk.enable = true;
      };
    };
}
