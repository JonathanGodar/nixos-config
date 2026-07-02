{ ... }:
{
  flake.modules.nixos.syncthing =
    { ... }:
    {

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

  flake.modules.homeManager.syncthing =
    { ... }:
    {
      services.syncthing = {
        enable = true;
      };
    };
}
