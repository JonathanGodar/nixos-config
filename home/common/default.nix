{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];
  programs.nix-index-database.comma.enable = true;

  preconf = {
    hyprland_de.enable = true;
    kitty.enable = true;
    nu.enable = true;
    catppuccin.enable = true;
    nvim.enable = true;
    obsidian.enable = true;
    vicinae.enable = true;
  };

  home = {
    username = "jonathan";
    homeDirectory = "/home/jonathan";
    stateVersion = "24.05";
  };

  services.syncthing.enable = true;
  qt.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;

      nix-direnv.enable = true;
    };
    rofi = {
      enable = true;
      # package = pkgs.rofi-wayland;
    };
    firefox = {
      enable = true;
      # Due to change in default and my older home state version
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.default.extensions.force = true;
    };
    home-manager.enable = true;
  };

  catppuccin.thunderbird.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.packages = with pkgs; [
    dconf # For setting gtk dark theme
    blueman
    overskride
    killall

    # For analyzing diskspace left
    ncdu

    go
    prismlauncher
    openjdk
    # (prismlauncher.override {
    #   jdks = [
    #   pkgs.jdk21 pkgs.jdk17 pkgs.jdk8
    #   ];
    # })

    cargo
    rustc

    httpie

    vlc
    obs-studio

    # inputs.nixvim.packages.${pkgs.system}.default

    ncdu # Analyze disk usage
    tldr # "man" in short form

    # Needed to make the desktopEntries
    xdg-utils

    nemo
    navigateOpenWindows

    chromium
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

    freecad
    prusa-slicer

    codex
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "sioyek.desktop" ]; # Replace with your preferred viewer
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.file."${config.xdg.configHome}/sioyek/keys_user.config".text = ''
    next_page <C-d>
    previous_page <C-u>
  '';

  xdg.desktopEntries = {
    ocrCopy =
      let
        copy-script = pkgs.writeShellApplication {
          name = "ocrcopy";
          runtimeInputs = with pkgs; [
            grim
            slurp
            tesseract
            wl-clipboard
          ];
          text = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
        };
      in
      {
        name = "OCR copy screen area";
        exec = "${lib.getExe copy-script}";
      };
  };
}
