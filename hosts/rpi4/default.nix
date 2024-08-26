{
  pkgs,
  inputs,
  ...
}: {
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

  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Niklasson Godar";
    extraGroups = ["networkmanager" "wheel"];
    packages = [];
    openssh.authorizedKeys.keys = [
      (builtins.readFile
        ./../../public_keys/faccun.pub)
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing
    22
  ];
  networking.firewall.allowedUDPPorts = [
    22
    # Syncthing
    22000
    21027
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # RPI4 specific
  environment.noXlibs = false;
}
