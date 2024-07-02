# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, catppuccin, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
    ];

  # Bootloader.
  boot.loader = {
  	systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;

    timeout = 1;
  };


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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.desktopManager.plasma6.enable = true;

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

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "jonathan";

  # Install firefox.
  programs.firefox.enable = true;

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


  # Or disable the firewall altogether.

  # networking.firewall.enable = false;


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
