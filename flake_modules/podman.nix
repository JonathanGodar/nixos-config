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
    };
}
