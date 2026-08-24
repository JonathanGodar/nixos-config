{
  flake.modules.homeManager.zoxide = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
