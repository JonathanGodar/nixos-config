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
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        DOMAIN = "https://pass.ngodag.com";
      };
    };
  };
}
