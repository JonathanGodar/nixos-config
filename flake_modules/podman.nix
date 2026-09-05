{ ... }:
{
  flake.modules.nixos.podman =
    {
      pkgs,
      ...
    }:
    {
      virtualisation.podman.enable = true;
      environment.systemPackages = with pkgs; [
        podman-compose
      ];

      virtualisation.containers.registries.search = [
        "docker.io"
      ];

    };
}
