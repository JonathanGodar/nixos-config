{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    preconf.spotify.enable = lib.mkEnableOption "Enable spotify";
  };

  config = lib.mkIf config.preconf.spotify.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];

    networking.firewall = {
      allowedTCPPorts = [ 57621 ];
      allowedUDPPorts = [ 5353 ];
    };

  };
}
