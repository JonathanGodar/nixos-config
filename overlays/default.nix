{ conifg, pkgs, lib, opentabletdriver-ugee, inputs, ... }:
{
  imports = [ ./focusWindow ./navigateOpenWindows ];
	nixpkgs.overlays = [ 
    inputs.mynvim.overlays.default 
    (final: prev:
    {
       opentabletdriver = (prev.opentabletdriver.override {
      buildDotnetModule = attrs: pkgs.buildDotnetModule (attrs // {
          dotnet-sdk = (with pkgs.dotnetCorePackages; combinePackages [sdk_6_0 sdk_7_0]);
          dotnet-runtime = (with pkgs.dotnetCorePackages; combinePackages [sdk_6_0 sdk_7_0]);
          nugetDeps = ./deps.nix;
          disabledTests = attrs.disabledTests ++ [ "OpenTabletDriver.Tests.ConfigurationTest.Configurations_Are_Linted" ];
          dotnetInstallFlags = [];
        });
      }).overrideAttrs (old: {
        src = inputs.opentablet-ugee; # Flake input of for source.
      }); 

      # prev.opentabletdriver.overrideAttrs (old: {
      #   src = inputs.opentablet-ugee;
      #   # dotnet-sdk = [pkgs.dotnetCorePackages.sdk_7_0];
      #   dotnet-sdk = pkgs.dotnetCorePackages.sdk_7_0; # (with pkgs.dotnetCorePackages; combinePackages [sdk_6_0 sdk_7_0]);
      #   # dotnet-sdk = (with pkgs.dotnetCorePackages; combinePackages [sdk_6_0 sdk_7_0]);
      #   dotnetInstallFlags = [ ];
      #   # dotnetInstallFlags = [ "ALKJDASLKDJASLDKJASLKJ" ];
      # });
  })
  # (final: prev: {
  #   opentabletdriver = prev.opentabletdriver.overrideAttrs {
  #     src = inputs.opentablet-ugee;
  #   };
  # })
  ];
}
