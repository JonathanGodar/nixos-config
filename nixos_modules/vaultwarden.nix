{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    preconf.vaultwarden.enable = lib.mkEnableOption "Enable preconfigured vaultwarden";
  };
  config = lib.mkIf config.preconf.vaultwarden.enable {
    services.vaultwarden.enable = true;
  };
}
