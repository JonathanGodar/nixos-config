{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    preconf.alacritty.enable = lib.mkEnableOption "Enable preconfigured alacritty";
  };
  config = lib.mkIf config.preconf.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window.decorations = "None";
        shell.program = "tmux";
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
