{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.preconf.nu.enable = lib.mkEnableOption "Enable nushell";

  config = lib.mkIf config.preconf.nu.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      shellAliases = {
        lsa = "eza -la";
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos";

        nvim-update = "nix flake update lazyvim --flake ~/nixos";

        # Does not work :( (?)
        cd = "z";

        rebld = "nh os switch -a ~/nixos";
        q = "exit";

        # Nu specific
        fg = "job unfreeze";

        s = "atuin scripts";
        r = "atuin scripts run";
      };
    };

    programs.zoxide.enableNushellIntegration = true;
    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };

    programs.carapace.enable = true;
    programs.carapace.enableNushellIntegration = true;
    programs.eza.enableNushellIntegration = true;
    programs.direnv.enableNushellIntegration = true;

    programs.atuin = {
      enable = true;
      daemon.enable = true;
      settings = {
        sync_frequency = "0";
        sync_address = "https://atuin.${config.home_network_url}";
        invert = true;
      };
    };
    programs.atuin.enableNushellIntegration = true;
  };
}
