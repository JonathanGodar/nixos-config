{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.kth.enable = lib.mkEnableOption "Enable some things that are required for kth work";
  };

  config = lib.mkIf config.preconf.kth.enable {
    home.packages = with pkgs; [
      python3
      typst

      libreoffice
      # slack

      # gnumake
      # noweb
      # texlive.combined.scheme-small

      # rars
      # logisim-evolution
    ];
  };
}
