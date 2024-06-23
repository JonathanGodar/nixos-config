{ conifg, pkgs, lib, mynvim, ... }:
{
	nixpkgs.overlays = [ mynvim.overlays.default ];
}
