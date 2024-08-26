{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    preconf.cli.enable = lib.mkEnableOption "Enable Core cli programes";
  };

  config = lib.mkIf config.preconf.cli.enable {
    preconf.git.enable = true;
    preconf.starship.enable = true;
    preconf.zsh.enable = true;
    preconf.fzf.enable = true;
    preconf.zoxide.enable = true;

    programs.htop.enable = true;

    programs.zsh.shellAliases = {
      cd = "z";
      rebld = "nh os switch -a ~/nixos";
    };

    home.packages = with pkgs; [
      killall
      kondo # For removing unneeded files from software projects
      nh # Nix helper, provides nice diff when updating system
      gh #Github cli tool

      fd # Used somewhere (?)
      jq
      ripgrep
    ];
  };
}
