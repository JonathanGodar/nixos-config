{ ... }:
{
  flake.modules.nixos.podman =
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
