{ config, self, ... }:
let
  inherit (config.flake) meta;
in
{
  flake =
    let
      ntfy_internal_port = "8329";
    in
    {
      meta.services.ntfy-sh.url = "tun1.${meta.homeNetworkUrl}";

      modules.nixos =
        let
          ntfy_cli_user = "jonathan";
        in
        {
          notifaj =
            { pkgs, config, ... }:
            {
              # Wrapped ntfy with server and credentials set.
              age.secrets.ntfy_password = {
                file = ../secrets/ntfy_password.age;
                mode = "0444";
              };

              environment.systemPackages = [
                (pkgs.writeShellApplication {
                  name = "notifaj";
                  runtimeInputs = [ pkgs.ntfy-sh ];
                  text = ''
                    NTFY_HOST="https://${meta.services.ntfy-sh.url}" NTFY_USER="${ntfy_cli_user}:$(< ${config.age.secrets.ntfy_password.path})" ntfy "$@"
                  '';
                })
              ];
            };

          ntfy-sh = { config, ... }: {
            # imports = [
            #   self.modules.nixos.postgresql
            # ];

            services =
              # let
              #   db_user = config.services.ntfy-sh.user;
              # in
              {

                ntfy-sh = {
                  enable = true;
                  settings = {
                    listen-http = ":${ntfy_internal_port}";
                    auth-default-access = "deny-all";
                    behind-proxy = true;
                    upstream-base-url = "https://ntfy.sh"; # For IOS push notifications
                    # database-url = "postgresql:////${db_user}?host=/run/postgresql";
                    base-url = "https://${meta.services.ntfy-sh.url}";
                    enable-login = true;
                    require-login = true;
                    auth-users = [
                      # Bcrypted password.
                      "${ntfy_cli_user}:$2a$12$SUFdCao6OKZLA4/lRWjbYOA7DAys8BQOeXBM9FbueUdN30mLTxRxG:admin"
                    ];
                  };
                };

                caddy.virtualHosts.${meta.services.ntfy-sh.url}.extraConfig =
                  "reverse_proxy :${ntfy_internal_port}";

                # postgresql = {
                #   ensureUsers = [
                #     {
                #       name = db_user;
                #       ensureDBOwnership = true;
                #     }
                #   ];
                #   ensureDatabases = [ db_user ];
                # };
              };
          };
        };
    };
}
