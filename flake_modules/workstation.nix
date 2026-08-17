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
        podman

        notifaj

        media
        notifaj
        backup
        backup_drive
        backup_rpi4
        mullvad
        opentabletdriver
      ];

      age.identityPaths = [ "/home/jonathan/.ssh/id_ed25519" ];
      services.flatpak.enable = true;

      services.backup = {
        include_paths = [
          "/home/jonathan/"
        ];
      };

      # This is here since we do not want it together with the raspberry pi
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;

        timeout = 1;
      };

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
        base
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

        hyprpaper
        lazygit
        nvim
        nushell
        starship
        carapace
        comma
        direnv
      ];

      home.packages = with pkgs; [
        mattermost-desktop
        spotify
        rnote

        # Diskspace analyzer
        ncdu
        nemo

        ragenix

        fd
        ripgrep
      ];

      programs = {
        discord.enable = true;
        kitty.enable = true;
      };
    };
}
