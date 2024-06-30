# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, catppuccin, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
  	systemd-boot.enable = true;
	efi.canTouchEfiVariables = true;

	timeout = 1;
  };

  catppuccin.enable = true;

  networking.hostName = "faccun"; 

    nix.settings = {
      builders-use-substitutes = true;
      # extra substituters to add
      extra-substituters = [
          "https://anyrun.cachix.org"
      ];

      extra-trusted-public-keys = [
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };

  # Enables wayland support for chromium and electron based apps 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Music player daemon
  services.mpd.enable = true;

  xdg.portal = { 
    enable = true; 
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  xdg.mime.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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

# This is meant to make the suspend-timeout to 0 seconds but does not work at the moment
#  services.pipewire.wireplumber.extraConfig = {
#    	"monitor.alsa.rules" = [
#   {
#     "matches" = [
#       {
# 	"node.name" = "~alsa_input.*";
#       }
#       {
# 	"node.name" = "~alsa_output.*";
#       }
#     ];
#     actions = {
#       "update-props" = {
# 	"session.suspend-timeout-seconds" = 0;
#       };
#     };
#   }
# ];
#
#    };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jonathan = {
    isNormalUser = true;
    description = "Jonathan Niklasson Godar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "jonathan";

  # Install firefox.
  programs.firefox.enable = true;
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

  users.defaultUserShell = pkgs.zsh;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     brave
     helix
     git
     htop

     discord
     filelight
     vscode
     wezterm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.syncthing = {
  #   openDefaultPorts = true;
  #   # https://github.com/dustinlyons/nixos-config/blob/7d06bf749002418589ff97598d6b8fdb3404e37a/hosts/nixos/default.nix#L103
  #   # TODO Fix hardcoded user
  #   dataDir = "/home/jonathan/.local/share/syncthing";
  #   configDir = "/home/jonathan/.config/syncthing";
  #   user = "jonathan";
  #   group = "users";
  #   guiAddress = "127.0.0.1:8384";
  #   overrideFolders = false;
  #   overrideDevices = false;
  # };


  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    22000 # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    # Syncthing 
    22000
    21027
  ];
  # Or disable the firewall altogether.

  # networking.firewall.enable = false;

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

  # Enable nVidia - GPU 
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}
