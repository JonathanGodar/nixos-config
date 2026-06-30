{ self, ... }:
{
  flake.modules.nixos.worksation =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        gui
      ];
    };

  flake.modules.homeManager.worksation =
    { pkgs, ... }:
    {
      imports = with self.homeModlues; [
        gui
      ];

      home.packages = with pkgs; [
        discord
        mattermost
      ];

      programs.firefox.enable = true;
    };
}
