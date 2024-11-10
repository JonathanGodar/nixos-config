{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    preconf.kth.enable = lib.mkEnableOption "Enable some things that are required for kth work";
  };

  config = lib.mkIf config.preconf.git.enable {
    home.packages = with pkgs; [
      python3
      zoom-us
      vscode

      onlyoffice-bin
      libreoffice
      slack

      gnumake
      noweb
      # texlive denna är brutalt stor och lyckas aldrig installeras
      texlive.combined.scheme-medium

      matlab # Provided by nix-matlab overlay. Requires imperative installation. See the gitlab of the input
    ];
  };
}
