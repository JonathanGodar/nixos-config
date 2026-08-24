{ ... }:
{
  flake.modules.homeManager.firefox =
    { config, ... }:
    {
      programs.firefox = {
        enable = true;
        # Due to change in default and my older home state version
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.default.extensions.force = true;
      };

      xdg.mimeApps = {
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };
    };

}
