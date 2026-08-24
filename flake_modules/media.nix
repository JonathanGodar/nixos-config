{

  flake.modules.nixos.media = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vlc
    ];

    services.avahi.enable = true;

  };

}
