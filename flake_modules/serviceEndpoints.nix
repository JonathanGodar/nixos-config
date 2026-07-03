{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.flake.serviceEndpoints = lib.mkOption {
    type = types.lazyAttrsOf types.str;
    default = { };
    description = "Urls for self-hosted services";
  };
}
