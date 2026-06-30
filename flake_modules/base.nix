{ self, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        nix
      ];

      programs = {
        git.enable = true;
      };

      hardware = {
        bluetooth.enable = true; # enables support for Bluetooth
        bluetooth.powerOnBoot = true;
      };

      # Bootloader.
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;

        timeout = 1;
      };

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
      networking = {
        networkmanager.enable = true;

        # Open ports in the firewall.
        firewall.allowedTCPPorts = [
          22000 # Syncthing
        ];
        firewall.allowedUDPPorts = [
          # Syncthing
          22000
          21027
        ];
      };

      # Configure console keymap
      console.keyMap = "sv-latin1";

      users.users.jonathan = {
        isNormalUser = true;
        description = "Jonathan Niklasson Godar";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [ ];
      };

      users.defaultUserShell = pkgs.zsh;

      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "24.05"; # Did you read the comment?
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
}
