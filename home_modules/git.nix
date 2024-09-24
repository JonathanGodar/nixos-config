{
  lib,
  config,
  ...
}: {
  options = {
    preconf.git.enable = lib.mkEnableOption "Enable git with my settings";
  };

  config = lib.mkIf config.preconf.git.enable {
    programs.git = {
      enable = true;
      userName = "Jonathan Niklasson Godar";
      userEmail = "jonathan.godar@hotmail.com";

      difftastic.enable = true;
      extraConfig = {
        rerere.enabled = true;
        pull.rebase = false;
        push.autoSetupRemote = true;
      };
    };
  };
}
