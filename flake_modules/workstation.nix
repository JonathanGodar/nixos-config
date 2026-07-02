{ self, ... }:
let
  use_modules = [
    "gui"
    "base"
    "hyprland"
  ];
in
{
  # Enables options set for all workstations
  flake.modules.nixos.workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        base
        gui
        hyprland
        catppuccin

        syncthing # Opens ports
      ];
    };

  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        gui
        nvim
        catppuccin
        homeManager
        ghostty
        vicinae
        syncthing
      ];

      home.packages = with pkgs; [
        mattermost
        spotify
      ];

      programs = {
        firefox.enable = true;
        discord.enable = true;
        kitty.enable = true;
        nh.enable = true;
      };
    };
}
