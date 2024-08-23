{
  config,
  lib,
  ...
}: {
  options.preconf.lazygit.enable = lib.mkEnableOption "Enable lazygit";
  config = lib.mkIf config.preconf.lazygit.enable {
    programs.lazygit.enable = true;
  };
}
