{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [
    # Not really sure what this is for - chat said it gives better type checking, flake-parts dont mention this.
    # It seems like this lets me use flake.modlues.nixos and flake.modules.homeManager instead and gives better
    # typechecking instead. Used by https://github.com/MrSom3body/dotfiles which seems to be a good config.
    inputs.flake-parts.flakeModules.modules
  ];

  # flake.lib.loadHMModules =
  #   let
  #     hm = self.modules.homeManager;
  #   in
  #   modules: (lib.map (mod: hm.${mod}) (lib.filter (mod: builtins.hasAttr mod hm) modules));
  #
  # flake.lib.loadNixModules =
  #   let
  #     nix = self.modules.nixos;
  #   in
  #   modules: (lib.map (mod: nix.${mod}) (lib.filter (mod: builtins.hasAttr mod nix) modules));
}
