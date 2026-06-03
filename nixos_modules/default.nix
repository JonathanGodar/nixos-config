{ ... }:
{
  imports = [
    ./backup.nix
    ./keyd.nix
    ./vaultwarden.nix
    ./ntfy.nix
    ./virtualbox.nix
    ./external-backup.nix
    ./spotify.nix
    ./immich.nix
    ./immich-ml.nix
    ./postgresql.nix
  ];
}
