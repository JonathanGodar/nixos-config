{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    preconf.cli_full.enable = lib.mkEnableOption "Enable CLI programes";
  };

  config = lib.mkIf config.preconf.cli_full.enable {
    preconf.cli.enable = true;
    preconf.tmux.enable = true;
    preconf.lazygit.enable = true;
    programs.bat.enable = true;

    home.packages = with pkgs; [
      # Alternative ls
      eza
    ];

    programs.zsh.shellAliases = {
      lsa = lib.mkForce "eza -F always --icons auto -la";
      lz = "lazygit";
      ls = "eza";
      cat = "bat";
    };
  };
}
