{ config, lib, pkgs, ... }: {
    options.changeWallpaper.wallpaperPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
    config.nixpkgs.overlays = [
      (self: super: {
      })
    ];
}
