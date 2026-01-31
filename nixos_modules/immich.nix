{
  inputs,
  pkgs,
  system,
  lib,
  config,
  ...
}:
{
  options.preconf.immich.enable = lib.mkEnableOption "Enable preconfigured immich";

  config = lib.mkIf config.preconf.immich.enable {
    services.immich = {
      enable = true;
      machine-learning.enable = false;

      # TODO REMOVE, only for testing
      openFirewall = true;
    };

  };
}
