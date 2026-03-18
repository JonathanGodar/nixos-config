{
  lib,
  config,
  ...
}:
{
  options = {
    preconf.git.enable = lib.mkEnableOption "Enable git with my settings";
  };

  config = lib.mkIf config.preconf.git.enable {
    programs = {
      git = {
        enable = true;

        settings = {
          rerere.enabled = true;
          pull.rebase = false;
          push.autoSetupRemote = true;
          user = {
            name = "Jonathan Niklasson Godar";
            email = "jonathan.godar@hotmail.com";
          };
          init.defaultBranch = "main";
        };
      };

      difftastic = {
        enable = true;
        git.enable = true;
      };
    };
  };
}
