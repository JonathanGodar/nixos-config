{
  flake.modules.nixos.mullvad = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.mullvad-vpn # Make the mullvad gui available
    ];
    services.mullvad-vpn.enable = true;
  };
}
