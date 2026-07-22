{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.flake.meta = {
    homeNetworkUrl = lib.mkOption {
      type = types.str;
      default = "ngodag.com";
      description = "Home Network Url";
    };

    services = lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            url = lib.mkOption {
              type = types.str;
              description = "Service endpoint";
            };
          };
        }
      );
      description = "Urls for self-hosted services";
    };
  };
}
