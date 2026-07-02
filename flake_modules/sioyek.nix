{ ... }:
{
  flake.modules.homeManager.sioyek =
    { ... }:
    {
      programs.sioyek.enable = true;

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [ "sioyek.desktop" ]; # Replace with your preferred viewer
      };
    };
}
