{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    preconf.kitty.enable = lib.mkEnableOption "Enable preconfigured kitty";
  };
  config = lib.mkIf config.preconf.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        terminal = "tmux";
        # font = "JetBrains Mono Nerd Font";
        # font.= {
        #   family = "JetBrains Mono Nerd Font";
        #   style = "Medium";
        # };
        # font.bold = {
        #   family = "JetBrains Mono Nerd Font";
        #   style = "Bold";
        # };
        # font.italic = {
        #   family = "JetBrains Mono Nerd Font";
        #   style = "MediumItalic";
        # };
        # font.bold_italic = {
        #   family = "JetBrains Mono Nerd Font";
        #   style = "BoldItalic";
        # };
      };
    };
  };
}
