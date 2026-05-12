# Edit this configuration file to define hat should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  catppuccin,
  inputs,
  ...
}:
let
  backup_helpers = import ../../nixos_modules/backup_helpers.nix { };
  to_rpi_job_name = "faccback";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common
  ];

  # systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (name: value: nameValuePair "borgbackup-job-${name}")
  #
  # systemd.timers."borgbackup-job-faccback".timerConfig.Persistent = true;

  systemd = {
    services."borgbackup-job-${to_rpi_job_name}" = {
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };
  };

  services.borgbackup.jobs = {
    faccback =
      let
        notify-send = lib.getExe pkgs.libnotify;
      in
      {
        persistentTimer = true;

        preHook = ''
          if [ -S /run/user/1000/bus ]; then
            ${notify-send} -t 0 "Starting ->RPI backup"
          fi
        '';

        postHook = ''
          if [ -S /run/user/1000/bus ]; then
            if [[ $exitStatus -eq 0 ]]; then
              ${notify-send} -t 0 "Backup -> RPI done"
            else
              ${notify-send} -u critical -t 0 "Backup  -> RPI failed" "Backup job exited with status $exitStatus"
            fi
          fi
        '';

        paths = "/home/jonathan/";

        exclude =
          (map (path: "/home/jonathan/" + path) backup_helpers.home_ignore_directories)
          ++ backup_helpers.ignore_directories;

        environment = {
          BORG_RSH = "ssh -i /home/jonathan/.ssh/id_ed25519";

          # Required to let notify-session access DBUS.
          # This is really ugly because i have hard coded the my users UID (which is 1000).
          DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        };

        extraCreateArgs = "--verbose --stats";

        user = "jonathan";
        # Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus

        repo = "borg@${config.home_network_url}:./";
        encryption.mode = "none";
        compression = "auto,lzma";
        startAt = "daily";
      };
  };

  # services.immich = {
  #   enable = true;
  #   accelerationDevices = null;
  # };

  # preconf.immich-ml = {
  #   enable = true;
  #   host = "192.168.1.83";
  #   workers = 8;
  # };

  # services.immich.machine-learning.environment.IMMICH_HOST = lib.mkForce "192.168.1.83";
  #
  # users.users.immich.extraGroups = [
  #   "video"
  #   "render"
  # ];

  networking.hostName = "faccun";
  nix.settings = {
    builders-use-substitutes = true;
  };

  networking.hostId = "354736d9";
  programs.steam.enable = true;
  services.flatpak.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # services.desktopManager.plasma6.enable = true;

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
    git
    htop

    discord
    vscode
    wezterm
  ];

  # boot.zfs.enabled = true;
  # boot.supportedFilesystems = [ "zfs" ];
  # services.zfs.enable = true;

  # services.ddclient = {
  #   enable = true;
  #   protocol = "namecheap";
  #   username = "${config.home_network_url}";
  #   passwordFile = "/home/jonathan/misc/secrets/namecheap_ddns_password";
  #   domains = ["@" "*"];
  # };

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

  networking.firewall.allowedTCPPorts = [
    3344
  ];

  # networking.firewall.enable = false;
  #

  # Enable nVidia - GPU
  hardware.graphics = {
    enable = true;
  };

  preconf.ntfy = {
    enable = true;
    subdomain = "faccun";
    smtp_subdomain = "ntfy-mx";
  };
  # ntfy.settings.base-url = "https://faccun.${config.home_network_url}";

  # To be able to emulate RASPI-4
  boot = {
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0
    '';

    binfmt = {
      emulatedSystems = [ "aarch64-linux" ];

      # Make nixos-enter work with systems of different architectures
      preferStaticEmulators = true;
    };
  };

  # systemd.binfmt.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

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
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  environment.etc."nextcloud-admin-pass".text = "hejsanpådigsan";
  services.nextcloud = {
    # enable = true;
    hostName = "localhost";

    # Need to manually increment with every major upgrade.
    package = pkgs.nextcloud30;

    # Let NixOS install and configure the database automatically.
    database.createLocally = true;
    # Let NixOS install and configure Redis caching automatically.
    configureRedis = true;

    # Increase the maximum file upload size to avoid problems uploading videos.
    maxUploadSize = "4G";
    # https = true;
    # enableBrokenCiphersForSSE = false;

    # autoUpdateApps.enable = true;
    # extraAppsEnable = true;
    # extraApps = with config.services.nextcloud.package.packages.apps; {
    #   # List of apps we want to install and are already packaged in
    #   # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
    #   inherit calendar contacts mail notes onlyoffice tasks;
    #
    #   # Custom app installation example.
    #   cookbook = pkgs.fetchNextcloudApp rec {
    #     url =
    #       "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
    #     sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
    #   };
    # };
    #
    config = {
      # overwriteProtocol = "https";
      # defaultPhoneRegion = "PT";
      dbtype = "sqlite";
      adminuser = "admins";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
  };

  # onlyoffice = {
  #   enable = true;
  #   hostname = "onlyoffice.example.com";
  # };

  # services.nextcloud = {
  #   enable = true;
  #   hostName = "localhost";
  #
  #   database.createLocally = true;
  #   package = pkgs.nextcloud30;
  #
  #   config = {
  #     adminpassFile = "/home/jonathan/nixos/nextcloud_pass.txt";
  #     dbtype = "sqlite";
  #   };
  #   # extraAppsEnable = true;
  # };

}
