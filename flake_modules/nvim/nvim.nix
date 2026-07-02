{ ... }:
{
  flake.modules.homeManager.nvim =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config = {
        catppuccin.nvim.enable = false;

        # General nix config taken from https://github.com/LazyVim/LazyVim/discussions/1972#discussioncomment-15985196
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;

          withPython3 = false;
          withRuby = false;

          extraPackages = with pkgs; [
            git
            lazygit
            ripgrep
            fzf
            fd
            tree-sitter

            lua-language-server
            luarocks
            stylua

            # Nix
            nil
            nixfmt
            statix

            # Python
            pyright
            ruff

            # Shells
            bash-language-server
            nushell

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
            lua

            # C/C++
            gcc
            libclang

            # For tinymist
            websocat
            tinymist

            # Required runtimes
            nodejs

            # For file previewing
            imagemagick

            # For sql
            sqls
          ];

          plugins = with pkgs.vimPlugins; [
            lazy-nvim
          ];

          initLua =
            let
              treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
              treesitterGrammars = pkgs.symlinkJoin {
                name = "nvim-treesitter-grammars";
                paths = treesitter.dependencies;
              };

              plugins = with pkgs.vimPlugins; [
                lazy-nvim
              ];

              mkEntryFromDrv =
                drv:
                if lib.isDerivation drv then
                  {
                    name = "${lib.getName drv}";
                    path = drv;
                  }
                else
                  drv;

              lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
              # lua
            in
            ''
              require("lazy").setup({
                defaults = {
                  -- lazy = true,
                },
                dev = {
                  path = "${lazyPath}",
                  patterns = {"."},
                  fallback = true,
                },
                spec =  {
                  { "LazyVim/LazyVim", import="lazyvim.plugins" },
                  { import = "lazyvim.plugins.extras.lang.nix" },
                  { import = "extras" },
                  { import = "plugins" },

                  {
                    "nvim-treesitter/nvim-treesitter",
                    -- build = "",
                    -- opts = {
                    --   install_dir = "${treesitterGrammars}",
                    -- },
                  },
                  { import = "plugins" },
                },
                -- checker = { enabled = false }, -- disable automatic update checking
                -- install = { colorscheme = { "catppuccin" } },
              });
            '';

        };

        xdg.configFile."nvim/lua" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home_modules/nvim/lua";
          recursive = true;
        };

        xdg.configFile."nvim/lazy-lock.json" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home_modules/nvim/lazy-lock.json";
        };
      };
    };

}
