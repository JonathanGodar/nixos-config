{ lib, ... }:
{
  flake.modules.nixos.systemOptions = {
    options.systemOptions.flakePath = lib.mkOption {
      type = lib.types.str;
    };
  };
}
