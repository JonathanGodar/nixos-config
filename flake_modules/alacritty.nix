{
  flake.modules.homeManager.alacritty = {
    programs.alacritty = {
      enable = true;
      settings = {
        window.decorations = "None";
        terminal.shell.program = "tmux";
        font.normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Medium";
        };
        font.bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        font.italic = {
          family = "JetBrains Mono Nerd Font";
          style = "MediumItalic";
        };
        font.bold_italic = {
          family = "JetBrains Mono Nerd Font";
          style = "BoldItalic";
        };
      };
    };
  };
}
