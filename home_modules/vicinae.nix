{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.vicinae.enable = lib.mkEnableOption "Enable configured vicinae";
  };

  config = lib.mkIf config.preconf.vicinae.enable {
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
  };
}
