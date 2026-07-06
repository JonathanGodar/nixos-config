{
  flake.modules.nixos.jonathan =
    { pkgs, ... }:
    {
      users.users.jonathan = {
        isNormalUser = true;
        description = "Jonathan Niklasson Godar";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [ ];
      };

      users.defaultUserShell = pkgs.zsh;
    };
}
