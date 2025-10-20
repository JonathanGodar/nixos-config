{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.preconf.virtualbox = {
    enable = lib.mkEnableOption "Enable ntfy server";
  };

  config = lib.mkIf config.preconf.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "jonathan" ];
  };
}
