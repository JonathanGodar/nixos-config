{
  pkgs,
  config,
  inputs,
  # system,
  ...
}:
{
  imports = [ ../common ];

  preconf.cli_full.enable = true;
  preconf.kth.enable = true;
  preconf.matlab.enable = true;

  preconf.hyprland.extraMediaKeyKeybinds = true;

  programs.vicinae = {
    enable = true;
    systemd.enable = true;

    extensions = with inputs.vicinae-extensions.packages.${pkgs.system}; [
      nix
      it-tools
      bluetooth
      wifi-commander
      process-manager
      player-pilot
      pulseaudio
      power-profile
    ];
  };
  #   extensions = [
  # (config.lib.vicinae.mkExtension {
  # name = "test-extension";
  # src =
  # pkgs.fetchFromGitHub {
  # owner = "schromp";
  # repo = "vicinae-extensions";
  # rev = "f8be5c89393a336f773d679d22faf82d59631991";
  # sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
  # }
  # + "/test-extension";
  # }
  # (config.lib.vicinae.mkRayCastExtension {
  # name = "gif-search";
  # sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
  # rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
  # }
  # ]};

  home.packages = with pkgs; [
    brightnessctl
    discord
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      # monitor, resolution, position, scale
      "eDP-1, preferred, 0x0, 2"
      ", preferred, auto, 1"
    ];

    "$mod" = "SUPER";
    "$MAIN_MONITOR" = "DP-2";
    "$OTHER_MONITOR" = "DP-1";
  };
}
