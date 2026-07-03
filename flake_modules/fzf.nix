{
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      # TODO Exists in upstream HM - but inputs update needed
      # enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
