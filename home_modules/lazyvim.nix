{
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    preconf.lazyvim.enable = lib.mkEnableOption "Enable configured lazyvim";
  };

  config = lib.mkIf config.preconf.lazyvim.enable {
    # programs.neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   # extraConfig = ''
    #   #   lua require("config.lazy").setup()
    #   # '';
    # };

    # home.packages = inputs.lazyvim.requiredPackages;
    # xdg.configFile."nvim".source = inputs.lazyvim.luaConfig;
  };
}
