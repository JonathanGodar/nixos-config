{
  flake.modules.homeManager.carapace = {
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
