{ ... }:
{
  imports = [
    ./backup.nix
    ./vaultwarden.nix
    ./ntfy.nix
    ./virtualbox.nix
    ./external-backup.nix
  ];
}
