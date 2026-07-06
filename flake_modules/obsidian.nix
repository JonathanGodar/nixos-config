{
  flake.modules.homeManager.obsidian = {
    programs.obsidian = {
      enable = true;
      cli.enable = true;
      defaultSettings.app = {
        vimMode = true;
        showLineNumber = true;
        relativeLineNumbers = true;
      };
    };
  };
}
