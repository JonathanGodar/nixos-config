{
  flake.modules.homeManager.yazi = {
    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      shellWrapperName = "y";
    };
  };
}
