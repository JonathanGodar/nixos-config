{
  lib,
  inputs,
  config,
  ...
}: {
  options = {
    preconf.catppuccin.enable = lib.mkEnableOption "Enable configured catpuccin theme";
  };

  # imports = [
  #   inputs.catppuccin.homeManagerModules.catppuccin
  # ];

  config = lib.mkIf config.preconf.catppuccin.enable {
    catppuccin = {
      flavor = "mocha";
      enable = true;
    };

    qt = {
      # Required to use catppuccin style
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
