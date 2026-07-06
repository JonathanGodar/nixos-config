{
  flake.modules.homeManager.git = {
    programs = {
      git = {
        enable = true;
        signing.format = null;

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
    };
  };
}
