{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.preconf.nvim.enable = lib.mkEnableOption "Enable ";

  config = lib.mkIf config.preconf.nvim.enable {

    catppuccin.nvim.enable = false;
    # General nix config taken from https://github.com/LazyVim/LazyVim/discussions/1972#discussioncomment-15985196
    programs.neovim = {
      enable = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        lua-language-server
        stylua

        # Nix
        nil
        nixfmt

        # Python
        pyright
        ruff

        # Shells
        bash-language-server
        nushell

        # matlab-language-server
        jdt-language-server

        shfmt
        prettier
        tree-sitter

        # Typescript + javascript
        vtsls

        rust-analyzer
        rustfmt

        # Markdown
        markdownlint-cli2
        marksman

        zk

        # C/C++
        gcc
        libclang

        # For tinymist
        websocat
        tinymist

        # Required runtimes
        nodejs
      ];

      plugins = with pkgs.vimPlugins; [ lazy-nvim ];

      initLua = ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          spec =  {
            {"LazyVim/LazyVim", import="lazyvim.plugins"},
            { import = "plugins" },
          }
        })
      '';

    };

    xdg.configFile."nvim/lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home_modules/nvim/lua";
      recursive = true;
    };

    xdg.configFile."nvim/lazy-lock.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home_modules/nvim/lazy-lock.json";
    };

    # home.file = {
    #   ".config/nvim".source = {
    #   }
    # };
  };
}
