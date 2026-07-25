{
  flake.modules.homeManager.direnv = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      nix-direnv.enable = true;
    };
  };
}
