{ config, ... }: {
  flake.modules.nixos.jonathan =
    { pkgs, ... }:
    {
      # required for remote builds (https://nixos.wiki/wiki/Nixos-rebuild)
      nix.settings.trusted-users = [ "jonathan" ];

      users.users.jonathan = {
        isNormalUser = true;
        description = "Jonathan Niklasson Godar";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [ ];
        openssh.authorizedKeys.keys = with config.flake.meta.hosts; [
          wax9.publicKey
          faccun.publicKey
        ];
      };

      users.defaultUserShell = pkgs.zsh;
    };
}
