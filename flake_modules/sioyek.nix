{
  flake.modules.homeManager.sioyek =
    { config, pkgs, ... }:
    {
      programs.sioyek = {
        enable = true;
      };

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ];
      };

      home.file."${config.xdg.configHome}/sioyek/keys_user.config".text = ''
        next_page <C-d>
        previous_page <C-u>
      '';
    };
}
