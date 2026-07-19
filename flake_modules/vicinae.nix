{ inputs, ... }:
{
  flake.modules.homeManager.vicinae =
    {
      pkgs,
      ...
    }:
    {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;

        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          nix
          it-tools
          # bluetooth
          wifi-commander
          process-manager
          player-pilot
          pulseaudio
          power-profile
        ];
      };

      home.packages = with pkgs; [
        playerctl
      ];
    };
}
