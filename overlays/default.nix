{
  conifg,
  pkgs,
  pkgs-9f41,
  lib,
  opentabletdriver-ugee,
  inputs,
  ...
}:
{
  imports = [
    ./focusWindow
    ./navigateOpenWindows
  ];
  nixpkgs.overlays = [
  ];
}
