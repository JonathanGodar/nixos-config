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

      systemOptions = {
        flakePath = "/home/jonathan/nixos/";
      };
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
        zsh
        nh
        zellij
        starship
        carapace
        fzf
        # sioyek
        firefox
        atuin
      ];

      home.packages = with pkgs; [
        mattermost
        spotify
      ];

      programs = {
        discord.enable = true;
        kitty.enable = true;
        nh.enable = true;
      };
    };
}
