{ pkgs, ...}: 
{
    nixpkgs.overlays = [
      (self: super: {
        navigateOpenWindows = pkgs.writeShellApplication {
          name = "navigateOpenWindows";
          runtimeInputs = with pkgs; [jq hyprland rofi-wayland focusScript ];
          text = builtins.readFile ./navigateOpenWindows.sh;
        };
      })
    ];
}
