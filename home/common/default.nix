{
  pkgs,
  lib,
  inputs,
  ...
}: {
  preconf.hyprland_de.enable = true;

  home.username = "jonathan";
  home.homeDirectory = "/home/jonathan";

  services.syncthing.enable = true;
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-left = ["hyprland/workspaces" "hyprland/mode" "wlr/taskbar"];
        modules-center = ["hyprland/window"];
        modules-right = ["mpd" "bluetooth" "tray" "network" "wireplumber"];
      };
    };
  };

  qt.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    dconf # For setting gtk dark theme
    comma
    blueman
    overskride
    killall

    go
    prismlauncher
    openjdk

    cargo
    rustc

    inputs.nixvim.packages.${pkgs.system}.default

    dust # Analyze disk usage
    tldr # "man" in short form

    fuzzel # Is this used?

    # Needed to make the desktopEntries
    xdg-utils

    cinnamon.nemo
    navigateOpenWindows

    chromium
    webcord
    mattermost-desktop

    rnote
    sioyek

    grim
    slurp
    tesseract
    wl-clipboard
    cliphist

    tofi

    pavucontrol # Needed for waybar

    gimp

    kdePackages.polkit-kde-agent-1
  ];

  xdg.desktopEntries = {
    ocrCopy = let
      copy-script = pkgs.writeShellApplication {
        name = "ocrcopy";
        runtimeInputs = with pkgs; [grim slurp tesseract wl-clipboard];
        text = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
      };
    in {
      name = "OCR copy screen area";
      exec = "${lib.getExe copy-script}";
    };
  };
}
