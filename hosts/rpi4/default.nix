{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./base.nix

  ];
  # hardware.bluetooth.enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;
  # programs.dconf.enable = true;

  # Bootloader.
  # boot.loader = {
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true;
  #
  #   timeout = 1;
  # };
  #
  # catppuccin.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable networking
  # networking.networkmanager.enable = true;

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # required for remote builds (https://nixos.wiki/wiki/Nixos-rebuild)
  nix.settings.trusted-users = ["jonathan"];

  services.syncthing = {
    enable = true;
    # TODO Set this as a variable
    dataDir = "/mnt/ssd/syncthing";
  };

  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Niklasson Godar";
    extraGroups = ["networkmanager" "wheel"];
    packages = [];
    openssh.authorizedKeys.keys = [
      (builtins.readFile
        ./../../public_keys/faccun.pub)
      (builtins.readFile
        ./../../public_keys/wax9.pub)
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  # Make root have access to neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.borgbackup.repos = {
      borg_repo = {
        authorizedKeys = [
          # TODO Set to variable - duplication 
          (builtins.readFile
            ./../../public_keys/faccun.pub)
          (builtins.readFile
            ./../../public_keys/wax9.pub)
        ];
        path = "/mnt/ssd/borg";
      };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing
    80 # nginx web traffic
    22
  ];
  networking.firewall.allowedUDPPorts = [
    22
    # Syncthing
    22000
    21027
  ];

  services.rnote-export = {
    enable = true;
    user = "jonathan";
    group = "users";

    inputDirectory = "/mnt/ssd/syncthing/kth";
    includeString = "*/föreläsningar/F*.rnote";
  };

  services.nginx = {
    enable = true;

    virtualHosts."lillathea.asuscomm.com" = {
      root = "/var/lib/rnote-export/";
      locations."/" = {
        extraConfig = "autoindex on;";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
