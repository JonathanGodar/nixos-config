{pkgs, ...}: {
  imports = [../common];

  preconf.cli_full.enable = true;
  preconf.catppuccin.enable = true;

  home.packages = with pkgs; [
    brightnessctl
  ];
}
