{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    preconf.matlab.enable = lib.mkEnableOption "Enable matlab. Requires imperativ installation";
  };

  config = lib.mkIf config.preconf.matlab.enable {
    home.packages = with pkgs; [
      matlab # Provided by nix-matlab overlay. Requires imperative installation. See the gitlab of the input
    ];
  };
}
