{ ... }:
{

  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        direnv.disabled = false;
        directory.truncate_to_repo = false;
      };
    };
  };
}
