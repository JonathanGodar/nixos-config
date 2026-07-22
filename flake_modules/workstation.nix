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

        syncthing-ports # Opens ports
      ];

      # Open minecraft server firewall.
      networking.firewall = {
        allowedTCPPorts = [ 25565 ];
        allowedUDPPorts = [ 25565 ];
      };

      systemOptions = {
        flakePath = "/home/jonathan/nixos/";
      };
    };

  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [
        hyprland

        ashell
        gui
        catppuccin
        ghostty
        vicinae
        syncthing
        zellij
        sioyek
        obsidian
        cursors

        firefox
        prismlauncher

        homeManager

        hyprpaper
        zsh
        lazygit
        nvim
        nushell
        nh
        starship
        carapace
        fzf
        atuin
        yazi
        comma
        git
        zoxide
      ];

      home.packages = with pkgs; [
        mattermost-desktop
        spotify
        rnote
      ];

      programs = {
        discord.enable = true;
        kitty.enable = true;
      };
    };
}
