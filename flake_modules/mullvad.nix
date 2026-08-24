{
  flake.modules.nixos.mullvad = { pkgs, config, ... }: {
    environment.systemPackages = [
      pkgs.mullvad-vpn # Make the mullvad gui available
    ];

    age.secrets.mullvad_account = {
      file = ../secrets/mullvad_account.age;
      path = "/etc/mullvad-vpn/account-history.json";
    };

    services.mullvad-vpn.enable = true;
  };
}
