{
  flake.modules.homeManager.sioyek =
    { config, pkgs, ... }:
    {
      programs.sioyek = {
        enable = true;
        # Thanks mistral
        package = (
          pkgs.symlinkJoin {
            name = "sioyek";
            paths = [ pkgs.sioyek ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/sioyek \
                --set QT_QPA_PLATFORM xcb
            '';
          }
        );
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
