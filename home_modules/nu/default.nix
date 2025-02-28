{
  config,
  pkgs,
  lib,
  ...
}: {
  options.preconf.nu.enable = lib.mkEnableOption "Enable nushell";

  config = lib.mkIf config.preconf.nu.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      shellAliases = {
        lsa = "ls -la";
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
        cd = "z";
        rebld = "nh os switch -a ~/nixos";
        q = "exit";
      };
    };

    programs.zoxide.enableNushellIntegration = true;
    programs.carapace.enable = true;
    programs.carapace.enableNushellIntegration = true;
    programs.eza.enableNushellIntegration = true;
    programs.direnv.enableNushellIntegration = true;

    programs.atuin = {
      enable = true;
      settings = {
        sync_frequency = "0";
        sync_address = "https://atuin.ngodag.com";
        invert = true;
      };
    };
    programs.atuin.enableNushellIntegration = true;

    # programs.zsh = {
    #   enable = true;
    #   enableCompletion = true;
    #
    #   autosuggestion.enable = true;
    #
    #   history = {
    #     size = 100000;
    #   };
    #
    #   shellAliases = {
    #     lsa = "ls -la";
    #     rebuild = "sudo nixos-rebuild switch --flake ~/nixos";
    #     q = "exit";
    #   };
    #
    #   plugins = [
    #     {
    #       # https://discourse.nixos.org/t/zsh-users-how-do-you-manage-plugins/9199/8
    #       name = "zsh-vi-mode";
    #       src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
    #     }
    #     {
    #       name = "fzf-tab";
    #       src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    #     }
    #   ];
    #
    #   initExtraFirst = ''
    #     # Make it so that zsh-vi-mode does not override any later keybinding configurations
    #     ZVM_INIT_MODE=sourcing
    #   '';
    #
    #   initExtra = ''
    #     # Case insensitive completion
    #     zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    #     zstyle ':completion:*' menu no
    #
    #     # Supposed to make the <Ctrl-P> and N shortcuts "prefix sensitive"
    #     bindkey '^p' history-search-backward
    #     bindkey '^n' history-search-forward
    #
    #     FD_OPTIONS="--hidden --no-ignore . --exclude node_modules --exclude target --exclude __pycache__ --exclude .git -L"
    #     export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
    #     export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
    #     export MANPAGER='nvim +Man!'
    #   '';
    # };
  };
}
