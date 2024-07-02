{pkgs, inputs}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
		./overlays
  ];

  catppuccin.enable = true;

  # Enables wayland support for chromium and electron based apps 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  hardware.opentabletdriver = {
    enable = true;
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

  # Enable networking networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Music player daemon
  services.mpd.enable = true;

  xdg.portal = { 
    enable = true; 
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    	variant = "nodeadkeys";
    	layout = "se";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Niklasson Godar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.hyprland = { # Required for hyprland to work
    enable = true;
    xwayland.enable = true;
  };
  
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    22000 # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

	fonts.packages = with pkgs; [
		nerdfonts
	];

}
