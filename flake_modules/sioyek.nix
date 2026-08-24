{
  flake.modules.homeManager.sioyek =
    { config, ... }:
    {
      programs.sioyek.enable = true;

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ]; # Replace with your preferred viewer
      };

      home.file."${config.xdg.configHome}/sioyek/keys_user.config".text = ''
        next_page <C-d>
        previous_page <C-u>
      '';
    };
}
