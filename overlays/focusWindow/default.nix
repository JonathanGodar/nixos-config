{ pkgs, ... }: {
    nixpkgs.overlays = [
      (self: super: {
        focusScript = pkgs.writeShellApplication {
          name = "focusWindow";
          runtimeInputs = with pkgs; [jq hyprland rofi-wayland ripgrep];
          text = builtins.readFile ./focusWindow.sh;
        };
      })
    ];
}
