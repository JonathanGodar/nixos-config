{ ... }:
{
  flake.nixosModules.podman =
    {
      pkgs,
      ...
    }:
    {
      virtualization.podman.enable = true;
      environment.systemPackages = with pkgs; [
        podman-compose
      ];
    };
}
