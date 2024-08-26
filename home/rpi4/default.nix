{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.username = "jonathan";
  # Check why I had to use lib.mkForce?
  home.homeDirectory = lib.mkForce "/home/jonathan";

  preconf.cli.enable = true;

  # services.syncthing.enable = true;
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    killall
    # inputs.nixvim.packages.${pkgs.system}.default

    dust # Analyze disk usage
    tldr # "man" in short form

    # Needed to make the desktopEntries
    xdg-utils
  ];

  # xdg.desktopEntries = {
  #   ocrCopy = let
  #     copy-script = pkgs.writeShellApplication {
  #       name = "ocrcopy";
  #       runtimeInputs = with pkgs; [grim slurp tesseract wl-clipboard];
  #       text = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
  #     };
  #   in {
  #     name = "OCR copy screen area";
  #     exec = "${lib.getExe copy-script}";
  #   };
  # };
}
