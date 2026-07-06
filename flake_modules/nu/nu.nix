{
  flake.modules.homeManager.nushell =
    {
      pkgs,
      lib,
      ...
    }:
    {

      programs.nushell = {
        enable = true;
        configFile.source = ./config.nu;
        shellAliases = {
          lsa = "${lib.getExe pkgs.eza} -la";
          rebuild = "sudo nixos-rebuild switch --flake ~/nixos";

          rebld = "${lib.getExe pkgs.nh} os switch -a ~/nixos";
          q = "exit";

          # Nu specific
          fg = "job unfreeze";

          s = "${lib.getExe pkgs.atuin} scripts";
          r = "${lib.getExe pkgs.atuin} scripts run";
        };
      };
    };
}
