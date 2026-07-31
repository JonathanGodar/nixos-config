{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    flake.meta.hosts = lib.mkOption {
      description = "Attribute set of hosts and their properties";
      type = types.attrsOf (
        types.submodule {
          options = {
            publicKey = lib.mkOption {
              type = types.str;
              description = "Public key for host";
            };
          };
        }
      );
    };
  };
}
