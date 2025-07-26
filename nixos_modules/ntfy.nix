{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.preconf.ntfy = {
    enable = lib.mkEnableOption "Enable ntfy server";
    port = lib.mkOption {
      type = lib.types.int;
      default = 3344;
      description = "Port which ntfy should run on";
    };
  };

  config = lib.mkIf config.preconf.ntfy.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://faccun.ngodag.com";
        listen-http = ":${toString config.preconf.ntfy.port}";
      };
    };
  };
}
