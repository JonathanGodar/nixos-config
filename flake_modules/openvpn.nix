{
  flake.modules.nixos.openvpn = { config, pkgs, ... }: {
    # Home network config
    age.identityPaths = [ "/home/jonathan/.ssh/id_ed25519" ];
    age.secrets.openvpn_client.file = ../secrets/ovpn_client.age;
    age.secrets.openvpn_auth_user_pass.file = ../secrets/openvpn_auth_user_pass.age;

    environment.etc."test.txt".text = ''
      ${config.age.secrets.openvpn_client.path}
    '';

    # services.openvpn = {
    #   servers.home = {
    #     config = "
    #       auth-user-pass ${config.age.secrets.openvpn_auth_user_pass.path}
    #       config ${config.age.secrets.openvpn_client.path}
    #       ";
    #   };
    # };
    # environment.systemPackages = with pkgs; [
    #   networkmanager-openvpn
    # ];

  };
}
