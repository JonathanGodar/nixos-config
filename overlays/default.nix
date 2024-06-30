{ conifg, pkgs, lib, mynvim, ... }:
{
  imports = [ ./focusWindow ./navigateOpenWindows ];
	nixpkgs.overlays = [ mynvim.overlays.default ];
}
