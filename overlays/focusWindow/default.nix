{ pkgs, ... }:
{
  config.nixpkgs.overlays = [
    (self: super: {
      focusScript = pkgs.writeShellApplication {
        name = "focusWindow";
        runtimeInputs = with pkgs; [
          jq
          hyprland
          rofi
          ripgrep
        ];
        text = builtins.readFile ./focusWindow.sh;
      };
    })
  ];
}
