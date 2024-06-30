{ config, pkgs, lib, catppuccin, inputs, ...}:
let
      focusApp = windowClass: failLaunch: "${lib.getExe focusScript} ${windowClass} ${failLaunch}";
      focusScript = pkgs.writeShellApplication {
        name = "focusWindow";
        runtimeInputs = with pkgs; [jq hyprland tofi ripgrep];
        text = builtins.readFile ./../focusWindow.sh;
      };


      wallpaperPaths = 
      lib.concatStringsSep " "
      (map (path: "${inputs.catppuccin-wallpaper-repo}/${path}") 
      [ 
        "landscapes/forrest.png"
        "landscapes/Clearnight.jpg"
        # "landscapes/Cloudsday.jpg"
        "landscapes/Cloudsnight.jpg"
        "landscapes/tropic_island_night.jpg"

        "minimalistic/list-horizontal.png"

        "misc/cat_bunnies.png"
        "misc/windows-error.jpg"
        "waves/cat-waves.png"
      ]);

      changeWallpaper = pkgs.writeShellApplication {
        name = "changeWallpaper";
        text = ''
        wallpapers=$(echo "${wallpaperPaths}" | tr ' ' '\n')
        chosenwallpaper=$(echo "$wallpapers" | shuf -n 1)
        
        hyprctl hyprpaper preload "$chosenwallpaper"
        hyprctl hyprpaper wallpaper ",$chosenwallpaper"

        hyprctl hyprpaper unload all
        echo "$chosenwallpaper"
        '';
      };

      # chatGptScript = pkgs.writeShellApplication {
      #   name = "chatGpt";
      #   runtimeInputs = with pkgs; [hyprland brave];
      #   text = builtins.readFile ./../chatgpt.sh;
      # };

      navigateOpenWindows = pkgs.writeShellApplication {
        name = "navigateOpenWindows";
        runtimeInputs = with pkgs; [jq hyprland tofi focusScript ];
        text = builtins.readFile ./../navigateOpenWindows.sh;
      };
    in
{
  imports = [ inputs.anyrun.homeManagerModules.default ];

	home.username = "jonathan";
	home.homeDirectory = "/home/jonathan";
	
	programs.starship = {
		enable = true;
		enableZshIntegration = true;
    settings = {
      direnv.disabled = false;
    };
	};

  services.syncthing.enable = true;
	home.stateVersion = "24.05";

	programs.home-manager.enable = true;

	programs.alacritty = {
		enable  = true; settings = {
			window.decorations = "None";
			shell.program = "tmux";
      font.normal = {
        family = "JetBrains Mono Nerd Font";
        style = "Medium";
      };
      font.bold = {
        family = "JetBrains Mono Nerd Font";
        style = "Bold";
      };
      font.italic= {
        family = "JetBrains Mono Nerd Font";
        style = "MediumItalic";
      };
      font.bold_italic= {
        family = "JetBrains Mono Nerd Font";
        style = "BoldItalic";
      };
		};
	};
	programs.bat.enable  = true;

  programs.anyrun = {
    enable = true;
    config = {
      layer = "overlay";
      plugins = with inputs.anyrun.packages.${pkgs.system}; [ applications rink shell symbols websearch stdin];
    };
    # package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
  };

  catppuccin.enable = true;

	# gtk.catppuccin.enable = true;
	# gtk.enable = true;

	programs.alacritty.catppuccin.enable = true;
	programs.bat.catppuccin.enable = true;
	programs.btop.catppuccin.enable = true;
	programs.fzf.catppuccin.enable = true;
	programs.git.delta.catppuccin.enable = true;
	programs.helix.catppuccin.enable = true;
	programs.lazygit.catppuccin.enable = true;
	programs.lazygit.enable = true;

	programs.waybar.catppuccin.enable = true;
	programs.waybar = {
    enable = true;
    settings = {
      mainBar =  {
        modules-left = [ "hyprland/workspaces" "hyprland/mode" "wlr/taskbar" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "mpd" "bluetooth" "tray" "pulseaudio" "wireplumber" ];
      };
    };
		#       "persistent_workspaces": {
		#           "1": [],
		#           "2": [],
		#           "3": [],
		#           "4": [],
		#       },
		#   },
  };

	# programs.neovim.enable = true;

	programs.starship.catppuccin.enable = true;
	programs.tmux.catppuccin.enable = true;
	programs.zsh.syntaxHighlighting.catppuccin.enable = true;

  # home.file."${config.home.homeDirectory}/hejsan.txt" = "${listOfWallpapers}";

  # qt.enable = true;
	qt.style.catppuccin.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
  };
	home.packages = with pkgs; [
		go

    cargo
    rustc

		dust # Analyze disk usage
		tldr # "man" in short form
		gh #Github cli tool

		fd
    jq
    ripgrep

    # Needed to make the desktopEntries
    xdg-utils

    cinnamon.nemo
    changeWallpaper
    navigateOpenWindows

    eza

    chromium
    webcord
		vesktop
		mattermost-desktop

    xfce.thunar
    rnote
    sioyek
    
    grim
    slurp
    tesseract
    wl-clipboard
    cliphist
    
    tofi

    pavucontrol # Needed for waybar

		nvim-pkg
    gimp
    
    # lxqt.lxqt-policykit
    kdePackages.polkit-kde-agent-1
	];

  xdg.desktopEntries = {
  ocrCopy =
  let 
    copy-script = pkgs.writeShellApplication {
      name = "ocrcopy";
      runtimeInputs = with pkgs; [ grim slurp tesseract wl-clipboard ];
      text = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
    };
  in
  {
    name = "OCR copy screen area";
    exec = "${lib.getExe copy-script}";
  };
  changeWallpaper = 
  {
    name = "Change Wallpaper";
    exec = "${lib.getExe changeWallpaper}";
  };
  };
	programs.tmux = {
		enable = true;

		shortcut = "Space";
		plugins = with pkgs.tmuxPlugins; [ sensible vim-tmux-navigator inputs.tmuxSessionX.packages."x86_64-linux".default ];

		terminal = "screen-256color";
		mouse = true;

		extraConfig = ''
		# Shift Alt vim keys to switch windows
		bind -n M-H previous-window
		bind -n M-L next-window

		# Resize windows with vim Motions 
		bind -r H resize-pane -L 5
		bind -r J resize-pane -D 5
		bind -r K resize-pane -U 5
		bind -r L resize-pane -R 5


    # Start lazygit instance
    bind g run-shell "tmux neww -c '#{pane_current_path}' lazygit"
    
		# Partially restore clear screen
		bind C-l send-keys 'C-l'

		# Force true colors
		set-option -ga terminal-overrides ",*:Tc"

		# Make <Leader> r reload the config
		unbind r
		bind r source-file ~/.config/tmux/tmux.conf 
		set-option -g status-position top

		# Make the numbering of windows and panes more sane
		set -g base-index 1
		set -g renumber-windows 1
		setw -g pane-base-index 1

		# New windows start in the same directory as the current window
		bind-key c new-window -c "#{pane_current_path}"

		# New panes split horizontally in the same directory as the current pane
		bind-key % split-window -h -c "#{pane_current_path}"

		# New panes split vertically in the same directory as the current pane
		bind-key '"' split-window -v -c "#{pane_current_path}" '';
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;

		autosuggestion.enable = true;
		# Already enabled above when setting catppuccin
		# syntaxHighlighting.enable = true;

		history = {
			size=100000;
		};

		shellAliases = {
			lsa = "eza -F always --icons auto -la";
			lz = "lazygit";
			cd = "z";
      ls = "eza";
			rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
			q = "exit";

			cat = "bat";
		};

		plugins = [
			{
			 	# https://discourse.nixos.org/t/zsh-users-how-do-you-manage-plugins/9199/8
			 	name = "zsh-vi-mode";
			 	src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
			}
			{
				name = "fzf-tab";
				src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";

			}
		];
		initExtraFirst = ''
# Make it so that zsh-vi-mode does not override any later keybinding configurations
ZVM_INIT_MODE=sourcing
'';

		initExtra = 
		''
# Case insensitive completion 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no 

# Supposed to make the <Ctrl-P> and N shortcuts "prefix sensitive"
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

FD_OPTIONS="--hidden --no-ignore . --exclude node_modules --exclude target --exclude __pycache__ --exclude .git -L"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export MANPAGER='nvim +Man!'
		'';

	};

	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.git = {
		enable = true;
		userName = "Jonathan Niklasson Godar";
		userEmail = "jonathan.godar@hotmail.com";

    extraConfig = {
      diff.tool = "nvimdiff";
      difftool.prompt = false;
      difftool.nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\""; # "nvim -c 'DiffviewOpen' -- $LOCAL $REMOTE";
    }; 
	};

	programs.zoxide.enable = true;

  wayland.windowManager.hyprland.catppuccin.enable = true;
  wayland.windowManager.hyprland.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "${./../../wallpapers/nix.png}";
      wallpaper = ",${./../../wallpapers/nix.png}";
    };
  };


  services.dunst = {
    enable = true;
    catppuccin.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
  windowrulev2 = "workspace special:Chat, initialtitle:^(chatgpt\.com_/)$";
#     windowrulev2 = float,class:(qalculate-gtk)
# windowrulev2 = workspace special:calculator,class:(qalculate-gtk)
# bind = SUPER, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &
    exec-once = [
      "waybar"
      "syncthing &"
      "dunst"
      "dbus-update-activation-environment --systemd --all"
      "${lib.getExe changeWallpaper}"
      "systemctl --user import-environment QT_QPA_PLATFORMTHEME"
      "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

      "wl-paste --type text --watch cliphist store" # Make text available in clipboard history
      "wl-paste --type image --watch cliphist store" # Make images available in clipboard history
    ];

    input = {
      kb_layout = "se";
      kb_variant = "nodeadkeys";
    };

    "$mod" = "SUPER";
    "$MAIN_MONITOR" = "DP-2";
    "$OTHER_MONITOR" = "DP-1";

    monitor = [
      "$OTHER_MONITOR, 1920x1080@144, 0x0, 1"
      "$MAIN_MONITOR, 1920x1080@144, 1920x0, 1"
      "Unknown-1, disable"
    ];

    workspace = [
      # TODO use range selectors instead
      "1, monitor:DP-2,default:true"
      "2, monitor:DP-2"
      "3, monitor:DP-2"
      "4, monitor:DP-2"
      "5, monitor:DP-2"
      "6, monitor:DP-2"
      "7, monitor:DP-2"

      "8, monitor:DP-1,default:true"
      "9, monitor:DP-1"
      "10, monitor:DP-1"
      # "2, border:false"
      # "r[1-7], monitor:$MAIN_MONITOR"
      # "r[8-10], monitor:$OTHER_MONITOR"
    ];

    
    # options.xdg.desktopEntries = {
    #   ocr-copy = {
    #     name = "ocr screen copy";
    #     exec = "grim -g \"$(slurp)\" - | tesseract - - | wl-copy";
    #   };
    # };


    bind = [
        "SUPER, g, exec, bash ${./../chatgpt.sh}" # hyprctl dispatch togglespecialworkspace Chat" # pgrep -f -- \"--app=https://chatgpt.com\" && hyprctl dispatch togglespecialworkspace Chat || brave --app \"https://chatgpt.com\" &"
        "SUPER_SHIFT, B, exec, ${focusApp "firefox" "firefox"}"
        "SUPER, B, exec, firefox"

        "$mod, Return, exec, alacritty"
        "SUPER_SHIFT, Return, exec, ${focusApp "Alacritty" "alacritty"}"

        "SUPER_SHIFT, c, killactive"
        "SUPER_SHIFT, q, exec, bash ${./../powerMenu.sh}"

        "SUPER, s, exec, ${focusApp "sioyek" "sioyek"}"
        "SUPER, n, exec, ${focusApp "com.github.flxzt.rnote" "rnote"}"
        "SUPER, o, exec, ${lib.getExe navigateOpenWindows}"
        ", Print, exec, grimblast copy area"

        # HJKL to switch active window
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod, SPACE, exec, anyrun"

        # HJKL to move active window position
        "SUPER_ALT, h, swapwindow, l"
        "SUPER_ALT, j, swapwindow, d"
        "SUPER_ALT, k, swapwindow, u"
        "SUPER_ALT, l, swapwindow, r"

        # View clipboard history
        "SUPER, V, exec, cliphist list | tofi | cliphist decode | wl-copy"

        # Copy screen selection as image
        ",Print, exec, grim -g \"$(slurp)\" - | wl-copy"  #grim -g \"$(slurp)\ | wl-copy"

        "SUPER, f, fullscreen, 0"
        "SUPER, m, fullscreen, 1"

      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      binde = [
        "SUPER_SHIFT, h, resizeactive, -20 0"
        "SUPER_SHIFT, j, resizeactive, 0 20"
        "SUPER_SHIFT, k, resizeactive, 0 -20"
        "SUPER_SHIFT, l, resizeactive, 20 0"

        # Raise and lower volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ];
  };
}
