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

    smtp_subdomain = lib.mkOption {
      type = lib.types.str;
      description = "Subdomain to run ntfy on";
    };

    subdomain = lib.mkOption {
      type = lib.types.str;
      description = "Subdomain to run ntfy on";
    };

    # auth-file-path = lib.mkOption {
    #   type = lib.types.str;
    #   default = "/mnt/ssd/ntfy/user.db";
    # };
  };

  config = lib.mkIf config.preconf.ntfy.enable {
    # systemd.tmpfiles.settings.rpi4-fs.${dirOf config.preconf.ntfy.auth-file-path}.d = {
    #   group = config.services.ntfy-sh.user;
    #   user = config.services.ntfy-sh.group;
    #   # mode = "0755";
    # };

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${config.preconf.ntfy.subdomain}.${config.home_network_url}";
        # base-url = config.preconf.ntfy.domain;
        upstream-base-url = "https://ntfy.sh";
        # auth-file = config.preconf.ntfy.auth-file-path;
        auth-users = [ "jonathan:$2a$12$spElE6eFXGBaJdFCKyZIlu4Jn34gDgVgoXC9ZiP0GHIYlwuqL9oUK:admin" ];
        behind-proxy = true;
        enable-login = true;

        smtp-server-listen = ":25";
        smtp-server-domain = "${config.preconf.ntfy.smtp_subdomain}.${config.home_network_url}";
        smtp-server-addr-prefix = "ntfy-";

        # Only allows users who have signed up to use the service
        auth-default-access = "deny-all";
        listen-http = ":${toString config.preconf.ntfy.port}";
      };
    };
  };
}
