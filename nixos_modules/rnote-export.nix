{
  inputs,
  pkgs,
  system,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.rnote-export.nixosModules.${system}.default
  ];

  options.preconf.bad-rnote = lib.mkEnableOption "Bad rnote export configuration no good.";

  config = lib.mkIf config.preconf.bad-rnote {
    services.rnote-export = {
      enable = true;
      inputDirectory = "/home/jonathan/kth";
      user = "jonathan";
      group = "users";
      includeString = "*/föreläsningar/*.rnote";
    };

    services.nginx = {
      enable = true;
      additionalModules = [ pkgs.nginxModules.fancyindex ];

      virtualHosts."192.168.1.83" = {
        root = "/var/lib/rnote-export/";
        locations."/" = {
          extraConfig = ''
            fancyindex on;
          '';
        };
      };
    };
  };
}
