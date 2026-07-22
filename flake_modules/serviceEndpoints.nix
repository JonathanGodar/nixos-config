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
      type = types.lazyAttrsOf types.str;
      default = {
        hejsan = "svejsan";
      };
      description = "Urls for self-hosted services";
    };
  };
}
