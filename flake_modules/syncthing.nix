{ self, ... }:
{
  flake.modules = {
    nixos = {
      syncthing = {
        imports = [ self.modules.nixos.syncthing-ports ];
        services.syncthing.enable = true;
      };

      syncthing-ports = {

        networking = {
          # Open ports in the firewall.
          firewall.allowedTCPPorts = [
            22000
          ];

          firewall.allowedUDPPorts = [
            22000
            21027
          ];
        };
      };
    };
    homeManager.syncthing = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
