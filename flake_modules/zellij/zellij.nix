{ ... }:
{
  flake.modules.homeManager.zellij =
    { pkgs, lib, ... }:
    {
      programs.zellij = {
        enable = true;
        extraConfig = builtins.readFile ./config.kdl;
        settings = {
          default_shell = "${lib.getExe pkgs.nushell}";
          default_layout = "${./layouts/better_default.kdl}";
        };
      };
    };
}
