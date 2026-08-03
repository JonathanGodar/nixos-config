let
  # These are the HOST ssh keys, meaning the once located in /etc/ssh/ and not in ~/.ssh
  faccun = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqMWOx4ppGP0zcHVJXuMxw+GN804CzvzXHftA91/AF7 jonathan.godar@gmail.com";
  wax9 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRnCES1B9fj5XY/P5WLoF+OaQUu7e1/3yoK5r8TA0qP jonathan.godar@gmail.com";
  rpi4 = "ngodag.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6jR2ESCbWpoLj63C7CeBlrVFnlXhJXqQeK7hLNy5U/";

  workstations = [
    faccun
    wax9
  ];

  server = [
    rpi4
  ];
in
{
  "namecheap_ddns_token.age".publicKeys = [ rpi4 ];
  "ovpn_client.age".publicKeys = [ wax9 ];
  "openvpn_auth_user_pass.age".publicKeys = [ wax9 ];
  "mullvad_account.age".publicKeys = workstations;
}
