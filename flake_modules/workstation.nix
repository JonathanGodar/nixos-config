{ self, ... }:
{
  flake.nixosModules.worksation =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        gui
      ];
    };

  flake.homeModules.worksation =
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
