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
        catppuccin
        jonathan

        hyprland
        keyd

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
        hyprland

        gui
        catppuccin
        ghostty
        vicinae
        syncthing
        zellij
        sioyek
        obsidian

        firefox
        prismlauncher

        homeManager

        zsh
        zoxide
        nvim
        nushell
        nh
        starship
        carapace
        fzf
        atuin
        yazi
        git
      ];

      home.packages = with pkgs; [
        mattermost-desktop
        spotify
      ];

      programs = {
        discord.enable = true;
        kitty.enable = true;
      };
    };
}
