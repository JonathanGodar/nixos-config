{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.keyd.enable = lib.mkEnableOption "Enable keyd";
  };

  config = lib.mkIf config.preconf.keyd.enable {
    services.keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];

        settings = {
          main = {
            # capslock = "overload(control, esc)";
            capslock = "esc";
            esc = "capslock";
          };
        };
      };
    };
  };
}
